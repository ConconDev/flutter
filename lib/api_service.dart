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

    // 요청 body
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
          // 토큰 저장
          await storage.write(
              key: 'authToken', value: response.headers['authorization']);

          // 토큰 저장 확인
          String? token = await storage.read(key: 'authToken');
          print('Saved token: $token');
          return {'token': token};
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

  // 토큰 저장하기
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
}
