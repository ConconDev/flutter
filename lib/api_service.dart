import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:concon/config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  final String baseUrl =
      'http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api';
  final storage = FlutterSecureStorage();

// 회원가입 API
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signUp');

    // 요청 body
    final body = jsonEncode({
      "password": password,
      "email": email,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // 응답이 숫자일 가능성 확인 후 처리
        try {
          final decodedResponse = jsonDecode(response.body);
          if (decodedResponse is Map<String, dynamic>) {
            return decodedResponse;
          } else {
            // 응답이 숫자일 경우 처리
            return {'userId': decodedResponse};
          }
        } catch (e) {
          // JSON 디코딩 오류가 발생하면, 숫자일 가능성 고려
          if (int.tryParse(response.body) != null) {
            return {'userId': int.parse(response.body)};
          } else {
            return {'error': 'Unexpected response format: ${response.body}'};
          }
        }
      } else {
        return {
          'error':
              '다음 오류로 인해 회원가입이 불가합니다\n${response.statusCode} ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // 로그인 API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(
        'http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/auth/login');
    final headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    print("Request URL: $url");
    print("Request headers: $headers");
    print("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: utf8.encode(jsonEncode(body)), // UTF-8로 인코딩된 JSON 본문
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded response body: $decodedBody');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.headers.containsKey('authorization')) {
          print("토큰 있음");
          // 토큰과 발행 시간 저장
          await storage.write(
              key: 'authToken', value: response.headers['authorization']);
          print(response.headers['authorization']);
          await storage.write(
              key: 'tokenIssuedAt', value: DateTime.now().toIso8601String());

          print('Saved token: ${response.headers['authorization']}');
          return {'token': response.headers['authorization']};
        } else {
          throw Exception('Authorization header not found');
        }
      } else {
        // 오류 상태 처리
        print('Error response body: $decodedBody');
        String errorMessage;
        try {
          final bodyJson = jsonDecode(decodedBody);
          errorMessage = bodyJson['error'] ??
              '알 수 없는 오류가 발생했습니다.'; // 서버에서 반환한 오류 메시지 (error 필드 사용)
          print("Parsed error message: $errorMessage");
        } catch (e) {
          print('Error parsing response: $e');
          errorMessage =
              'Error: ${response.statusCode} ${response.reasonPhrase}'; // 기본 오류 메시지
        }

        // Bad credentials 처리
        if (errorMessage.contains('Bad credentials')) {
          return {'error': 'Bad credentials'}; // Bad credentials 오류 반환
        } else {
          return {'error': errorMessage};
        }
      }
    } catch (e) {
      print('An error occurred: $e');
      return {'error': 'An error occurred: $e'};
    }
  }

  // 저장된 토큰 가져오기
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }

  // 토큰 발행 시간 가져오기
  Future<DateTime?> getTokenIssuedAt() async {
    String? issuedAtStr = await storage.read(key: 'tokenIssuedAt');
    if (issuedAtStr != null) {
      return DateTime.parse(issuedAtStr);
    }
    return null;
  }

  // 토큰 만료 여부 확인 (10시간 만료)
  Future<bool> isTokenExpired() async {
    DateTime? issuedAt = await getTokenIssuedAt();
    if (issuedAt == null) return true;

    final expirationDuration = Duration(hours: 10);
    return DateTime.now().isAfter(issuedAt.add(expirationDuration));
  }

  // 자동 로그인
  Future<Map<String, dynamic>> autoLogin(String email, String password) async {
    if (await isTokenExpired()) {
      // 토큰이 만료된 경우 로그인 재시도
      return await login(email, password);
    } else {
      // 토큰이 유효한 경우
      String? token = await getToken();
      print("'token': $token");
      return {'token': token};
    }
  }

  // 로그아웃 API
  Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');

    // 저장된 토큰 가져오기
    String? token = await getToken();
    if (token == null) {
      print("토큰이 없어서 로그아웃을 성공으로 처리합니다.");
      return true;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // 로그아웃 성공 시 토큰 삭제
        await storage.delete(key: 'authToken');
        await storage.delete(key: 'tokenIssuedAt');
        await storage.delete(key: 'savedEmail');
        await storage.delete(key: 'savedPassword');

        // 삭제 후 확인 로그 추가
        String? tokenAfterLogout = await storage.read(key: 'authToken');
        print("로그아웃 후 토큰: $tokenAfterLogout"); // null이어야 정상 로그아웃

        return true;
      } else {
        print('Logout failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  // 회원 탈퇴 API
  Future<bool> deleteUser() async {
    final url = Uri.parse('$baseUrl/users');

    // 저장된 토큰 가져오기
    String? token = await getToken();
    if (token == null) return false; // 토큰이 없으면 탈퇴 불가

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        // 탈퇴 성공 시 토큰 및 모든 저장 데이터 삭제
        await storage.deleteAll();
        return true;
      } else {
        print('Delete user failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

// 상품명으로 itemId 및 brand 가져오기 API
  Future<Map<String, dynamic>?> fetchItemDetails(String itemName) async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse('$baseUrl/item?name=$itemName');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        print('Failed to fetch item details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching item details: $e');
      return null;
    }
  }

  // 쿠폰 등록 API
  Future<bool?> registerCoupon(int itemId, String barcode, String name,
      String expirationDate, int price) async {
    final url = Uri.parse('$baseUrl/coupons');
    final token = await getToken();
    if (token == null) {
      return null;
    }

    String formattedDate = expirationDate.replaceAll('.', '-');

    try {
      print(formattedDate);
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "itemId": itemId,
          "barcode": barcode,
          "name": name,
          "price": price,
          "expirationDate": formattedDate,
          "imageFileName": "example_image.jpg",
          "barcodeImage": "barcode_example.jpg",
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registering coupon: $e');
      return false;
    }
  }

  // 유저 검색 API
  Future<List<Map<String, dynamic>>?> searchUsers(String username) async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse('$baseUrl/users/search?username=$username');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        // JSON 데이터 파싱 및 예외 처리
        return jsonData.map((user) {
          return {
            'userId': user['userId'].toString(),
            'name': user['name'] ?? '',
            // profileUrl이 없으면 null로 설정 (UI에서 처리)
            'profileUrl': user['profileUrl'],
          };
        }).toList();
      } else {
        print('Failed to search users: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error searching users: $e');
      return null;
    }
  }

  // 친구 요청 API
  Future<http.Response?> sendFriendRequest(int friendId) async {
    String? token = await storage.read(key: 'authToken');
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/friend/$friendId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print(response.statusCode);
        print('Failed to send friend request: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending friend request: $e');
      return null;
    }
  }

// 친구 요청 취소 API
  Future<http.Response?> cancelFriendRequest(int friendshipId) async {
    String? token = await getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/friend/cancel/$friendshipId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        print("친구 요청 취소 성공");
        return response;
      } else {
        print("친구 요청 취소 실패: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Error cancelling friend request: $e');
      return null;
    }
  }

  // 친구 목록 조회 API
  Future<List<Map<String, dynamic>>?> getFriendsList() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse(
        'http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => {
                  'friendshipId': item['friendshipId'],
                  'name': item['name'],
                  'profileUrl': item['profileUrl'],
                  'status': item['status'],
                })
            .toList();
      }
    } catch (e) {
      print('Error fetching friends list: $e');
    }
    return null;
  }

  // 나에게 온 친구 요청 조회 API
  Future<List<Map<String, dynamic>>?> getFriendRequests() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse(
        'http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend/receiver');
    try {
      print(token);
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('나에게 온 친구 요청 조회 성공');
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => {
                  'friendshipId': item['friendshipId'],
                  'name': item['name'],
                  'profileUrl': item['profileUrl'],
                  'status': item['status'],
                })
            .toList();
      }
      print('나에게 온 친구 요청 조회 실패');
      print(response.statusCode);
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
    return null;
  }

  // 내가 보낸 친구 요청 조회 API
  Future<List<Map<String, dynamic>>?> getSentFriendRequests() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse(
        'http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend/sender');
    try {
      print(token);
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('내가 보낸 친구 요청 조회 성공');
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => {
                  'friendshipId': item['friendshipId'],
                  'name': item['name'],
                  'profileUrl': item['profileUrl'],
                  'status': item['status'],
                })
            .toList();
      }
      print('내가 보낸 친구 요청 조회 실패');
      print(response.statusCode);
    } catch (e) {
      print('Error fetching sent friend requests: $e');
    }
    return null;
  }

  // 친구 요청 승인 API
  Future<http.Response?> acceptFriendRequest(int friendshipId) async {
    final token = await getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/friend/accept/$friendshipId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        print("친구 요청 승인 성공");
        return response;
      } else {
        print("친구 요청 승인 실패: ${response.body}");
        return response;
      }
    } catch (e) {
      print("Error accepting friend request: $e");
      return null;
    }
  }

// 친구 요청 거절 API
  Future<http.Response?> denyFriendRequest(int friendshipId) async {
    final token = await getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/friend/deny/$friendshipId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        print("친구 요청 거절 성공");
        return response;
      } else {
        print("친구 요청 거절 실패: ${response.body}");
        return response;
      }
    } catch (e) {
      print("Error denying friend request: $e");
      return null;
    }
  }

  // 친구 삭제 API
  Future<bool> deleteFriend(int friendshipId) async {
    final token = await getToken(); // 저장된 토큰 가져오기
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/friend/$friendshipId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token, // 토큰 인증 헤더 추가
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("친구 삭제 성공");
        return true;
      } else {
        print("친구 삭제 실패:${response.statusCode}: ${response.body}");
        return false;
      }
    } catch (e) {
      print("친구 삭제 오류 발생: $e");
      return false;
    }
  }

// 내 정보 조회 API
  Future<Map<String, dynamic>?> getUserInfo() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse('$baseUrl/users');

    try {
      print(token);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse; // 성공 시 유저 정보 반환
      } else {
        print(response.statusCode);
        print('Failed to fetch user info: ${response.body}');
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return null; // 에러 발생 시 null 반환
    }
  }

   // 유저 정보 수정하기
Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> userData) async {
 final token = await getToken(); // 저장된 토큰 가져오기
    if (token == null) return {}; // 실패 시 빈 맵 반환

  final url = Uri.parse('$baseUrl/users');
  print(token);

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse; // JSON 전체 응답 반환 (여기서 photoModifyUrl 받아옴)
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return {}; // 실패 시 빈 맵 반환
  }
}


  // 이미지 업로드 URL에 PUT 요청으로 이미지 전송
Future<bool> uploadImage(File imageFile, String uploadUrl) async {
  // 이미지 파일의 크기를 확인
  int imageSize = imageFile.lengthSync();
  img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

  if (image == null) {
    print('Failed to decode image.');
    return false;
  }

  // PNG 형식인지 확인
  String fileExtension = imageFile.path.split('.').last.toLowerCase();
  List<int> imageBytes;

  // 파일 크기가 1MB를 넘으면 이미지 크기 조정
  if (imageSize > 1024 * 1024) {
    // 1MB 넘는 파일은 크기를 줄임 (퀄리티 조정)
    img.Image resized = img.copyResize(image, width: image.width ~/ 2, height: image.height ~/ 2); // 크기를 절반으로 줄임
    imageBytes = fileExtension == 'png' 
      ? img.encodePng(resized)
      : img.encodeJpg(resized, quality: 85); // JPG 파일의 경우 퀄리티 85로 압축
  } else {
    // 1MB 이하일 경우 크기 조정 없이 그대로 전송
    imageBytes = fileExtension == 'png'
      ? img.encodePng(image)
      : img.encodeJpg(image, quality: 85);
  }

  // Content-Type 설정
  String contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';

  final response = await http.put(
    Uri.parse(uploadUrl),
    headers: {
      'Content-Type': contentType,
    },
    body: imageBytes,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Image Upload Failed: ${response.body}');
    return false;
  }
}



//   // LumaAI API 연결을 위한 ChatGPT 프롬프트 상세 작성 요청 API
//   Future<String> generatePrompt(String imagePath) async {
//     const String apiKey = Config.openAIApiKey; // OpenAI API 키 입력
//     final Uri apiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

//     // ChatGPT 프롬프트 작성
//     String prompt = '''
//   Please describe this product in detail based on the image located at: $imagePath.
//   Create a detailed prompt for generating a 3D model of this product. Include its materials, texture, and any relevant visual details.
//   ''';

//     final response = await http.post(
//   apiUrl,
//   headers: {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $apiKey',
//   },
//   body: utf8.encode(jsonEncode({
//     "model": "gpt-3.5-turbo",
//     "messages": [
//       {"role": "system", "content": "You are a helpful assistant."},
//       {"role": "user", "content": prompt}
//     ],
//     "max_tokens": 150
//   })),
// );

// if (response.statusCode == 200) {
//   var responseData = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 응답 처리
//   var generatedPrompt = responseData['choices'][0]['message']['content'];
//   return generatedPrompt;
// } else {
//   throw Exception('Failed to generate prompt: ${response.statusCode}');
// }
//   }
  Future<String> generateLumaAIPrompt(String searchResult) async {
    const String apiKey = Config.openAIApiKey; // OpenAI API 키 입력
    final Uri apiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

    // Luma AI 용 프롬프트 작성 (간결하고 정확한 3D 모델 지시)
    String prompt = '''
  Please create a 3D model of the product described below and render a 360-degree horizontal rotation (left to right) around the product for a smooth and simple 5-second video.

  Product description:
  $searchResult

  Focus on generating a realistic and accurate 3D model based on the first image frame. The model should rotate smoothly without any additional effects or animations beyond the horizontal rotation. Ensure that the video highlights the product's key materials, textures, and details, emphasizing its physical structure in a clear and minimalistic manner.

  For example, if the product is a ceramic mug, the video should showcase the glossy texture and curvature of the mug, highlighting its shape as it rotates. The lighting should be neutral, allowing the product's natural characteristics to stand out without any distracting effects.
  ''';

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 500
      }),
    );

    if (response.statusCode == 200) {
      var responseData =
          jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩
      var generatedPrompt = responseData['choices'][0]['message']['content'];
      return generatedPrompt;
    } else {
      throw Exception('Failed to generate prompt: ${response.statusCode}');
    }
  }

  Future<String> searchGoogleCustom(String query) async {
    const String apiKey = Config.googleCloudApiKey; // 발급받은 API 키 입력
    const String cx = 'a49a7882ccdec43a0'; // 검색 엔진 ID 입력

    // 쿼리 인코딩
    final encodedQuery = Uri.encodeQueryComponent(query);

    final Uri apiUrl = Uri.parse(
      'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cx&q=$encodedQuery',
    );

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // 검색 결과가 있는지 확인하고 반환
        if (jsonData['items'] != null && jsonData['items'].isNotEmpty) {
          return jsonData['items'][0]['snippet']; // 첫 번째 결과의 요약된 정보 반환
        } else {
          return 'No results found for query: $query';
        }
      } else {
        throw Exception('Failed to search Google: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching Google: $e');
    }
  }

//   Future<String> searchDuckDuckGo(String query) async {
//   final Uri apiUrl = Uri.parse('https://api.duckduckgo.com/?q=$query&format=json');

//   final response = await http.get(apiUrl);

//   if (response.statusCode == 200) {
//     var jsonData = jsonDecode(response.body);
//     var relatedTopics = jsonData['RelatedTopics'];

//     // 관련된 주제 중 첫 번째 결과를 반환
//     if (relatedTopics != null && relatedTopics.isNotEmpty) {
//       return relatedTopics[0]['Text'];
//     } else {
//       return 'No relevant results found for $query.';
//     }
//   } else {
//     throw Exception('Failed to search DuckDuckGo: ${response.statusCode}');
//   }
// }

// 상태를 확인하고 완료될 때까지 기다리는 함수 추가
  Future<String> checkGenerationStatus(String id) async {
    const String lumaApiKey = Config.lumaApiKey;
    final Uri checkStatusUrl =
        Uri.parse('https://api.lumalabs.ai/dream-machine/v1/generations/$id');

    while (true) {
      var response = await http.get(
        checkStatusUrl,
        headers: {
          'Authorization': 'Bearer $lumaApiKey',
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['state'] == 'completed') {
          if (result['assets'] != null) {
            return result['assets']['url']; // 생성된 비디오 URL 반환
          } else {
            throw Exception('Assets not found.');
          }
        } else if (result['state'] == 'failed') {
          throw Exception('Generation failed: ${result['failure_reason']}');
        }
      } else {
        throw Exception('Failed to check status: ${response.statusCode}');
      }

      // 5초마다 상태를 확인
      await Future.delayed(Duration(seconds: 10));
    }
  }

// ChatGPT 프롬프트 기반 LumaAI에 3D 영상 제작 요청
  Future<String> sendPromptAndImageToLumaAI(String prompt) async {
    const String lumaApiKey = Config.lumaApiKey;
    final Uri lumaApiUrl =
        Uri.parse('https://api.lumalabs.ai/dream-machine/v1/generations');

    var imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/concon-bebd5.appspot.com/o/cafe_sample1.png?alt=media&token=00482f82-dbe2-4357-909c-ccba6b90d989';

    var response = await http.post(
      lumaApiUrl,
      headers: {
        'Authorization': 'Bearer $lumaApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        'aspect_ratio': '9:16',
        'keyframes': {
          'frame0': {
            'type': 'image',
            'url': imageUrl,
          }
        },
        'loop': true,
      }),
    );

    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      String id = result['id'];

      // 상태 체크 및 완료될 때까지 기다림
      return await checkGenerationStatus(id);
    } else {
      throw Exception('Failed to create 3D model: ${response.statusCode}');
    }
  }

// Future<String> generate3DVideo(String imagePath, String searchResult) async {
//   try {
//     // 프롬프트 생성
//     String prompt = await generateLumaAIPrompt(searchResult);

//     // 이미지 파일 경로를 파일로 변환
//     File imageFile = await getImageFileFromAssets(imagePath);

//     // Luma AI에 프롬프트와 이미지 전송
//     String videoUrl = await sendPromptAndImageToLumaAI(prompt, imageFile);

//     return videoUrl;
//   } catch (e) {
//     throw Exception('3D 영상 생성 실패: $e');
//   }
// }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path); // assets 폴더에서 이미지 파일 로드
    final tempDir = await getTemporaryDirectory(); // 임시 디렉토리 경로 가져오기
    final file = File('${tempDir.path}/temp_image.png'); // 임시 파일 생성
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)); // 파일 작성
    return file; // 파일 반환
  }

  Future<String> getChatbotResponse(
      String userQuestion, String gifticonInfo) async {
    // 대화 기록을 저장하는 리스트
    List<Map<String, String>> conversationHistory = [];
    String? summary; // 요약본 저장 변수

    const String apiKey = Config.openAIApiKey; // ChatGPT API 키
    final Uri apiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

    // 새로운 질문 추가
    conversationHistory.add({'role': 'user', 'content': userQuestion});

    // 5개 대화가 넘었을 때 요약 요청
    if (conversationHistory.length >= 5) {
      summary = await summarizeConversation(conversationHistory);
      conversationHistory.clear(); // 요약 후 대화 기록 초기화
    }

    print(gifticonInfo);

    // 프롬프트에 요약 내용 추가
    String prompt = '''
  너는 기프티콘에 관련된 질문에 답변하는 한국어 챗봇이야.
  아래 삽입되는 기프티콘에 대한 검색 정보를 바탕으로 사용자에게 적절한 답변을 해 줘.
  답변은 존댓말로 해 줘.
  최대 토큰 수를 200으로 설정했으니까, 반드시 200자 안에 문장이 완벽하게 끝날 수 있도록 답변해 줘.

  여기까지의 대화 요약:
  ${summary ?? '아직 요약된 대화가 없습니다.'}

  기프티콘에 대한 검색 정보: $gifticonInfo
  
  사용자 질문: $userQuestion
  ''';

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "너는 한국어로 대답하는 기프티콘 관련 질문을 처리하는 챗봇이야."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 300
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      conversationHistory.add({
        'role': 'assistant',
        'content': responseData['choices'][0]['message']['content']
      });
      return responseData['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get chatbot response: ${response.statusCode}');
    }
  }

  Future<String> summarizeConversation(
      List<Map<String, String>> history) async {
    const String apiKey = Config.openAIApiKey;
    final Uri apiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

    // 대화 내용 요약 요청 프롬프트
    String summarizePrompt = '''
  아래 대화를 간결하게 요약해 주세요. 요약 내용은 간결하고 중요한 대화 요점만 포함해주세요.
  
  대화 내용:
  ${history.map((message) => "${message['role']}: ${message['content']}").join('\n')}
  ''';

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "대화를 요약하는 역할입니다."},
          {"role": "user", "content": summarizePrompt}
        ],
        "max_tokens": 300
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData['choices'][0]['message']['content']; // 요약된 내용 반환
    } else {
      throw Exception(
          'Failed to summarize conversation: ${response.statusCode}');
    }
  }
}
