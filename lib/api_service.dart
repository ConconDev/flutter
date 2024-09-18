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
      "username": "exampleUser", // 실제 데이터로 변경 필요
      "gender": "FEMALE", // 실제 데이터로 변경 필요
      "age": 20, // 실제 데이터로 변경 필요
      "profileImageName": "default.png", // 실제 데이터로 변경 필요
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
        // 응답이 JSON 형식인지 확인
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
        return {'error': 'Failed to sign up. Response: ${response.body}'};
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
          await storage.write(
              key: 'tokenIssuedAt', value: DateTime.now().toIso8601String());

          print('Saved token: ${response.headers['authorization']}');
          return {'token': response.headers['authorization']};
        } else {
          throw Exception('Authorization header not found');
        }
      } else {
        print('Error response body: $decodedBody');
        return {'error': decodedBody.isNotEmpty ? jsonDecode(decodedBody)['message'] : 'Empty response body'};
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
        print("토큰 삭제 완료");
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
          'Authorization': 'Bearer $token',
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

}
