import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
      return {'error': '다음 오류로 인해 회원가입이 불가합니다\n${response.statusCode} ${response.body}'};
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

      if (response.statusCode == 200) {
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
        print('Error response body: $decodedBody');
        return {
          'error': decodedBody.isNotEmpty
              ? jsonDecode(decodedBody)['message']
              : 'Empty response body'
        };
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
  if (token == null) return false; // 토큰이 없으면 로그아웃 불가

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

    final url = Uri.parse('http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend');
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

    final url = Uri.parse('http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend/receiver');
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

    final url = Uri.parse('http://ec2-52-79-212-128.ap-northeast-2.compute.amazonaws.com:8080/api/friend/sender');
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
      }print('내가 보낸 친구 요청 조회 실패');
      print(response.statusCode);
    } catch (e) {
      print('Error fetching sent friend requests: $e');
    }
    return null;
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
}
