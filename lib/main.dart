import 'package:concon/screen/coupon/my_coupon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:concon/screen/on_boarding/sign_in.dart';
import 'package:concon/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  
  // ApiService 인스턴스 생성
  final ApiService apiService = ApiService();

  // 자동 로그인 체크
  bool isLoggedIn = await checkAutoLogin(apiService);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFFFF9900),
        selectionHandleColor: Color(0xFFFF9900),
      ),
    ),
    home: isLoggedIn ? MyCouponList() : SignInPage(), // 초기 화면 설정
  ));
}

// 자동 로그인 여부 확인
Future<bool> checkAutoLogin(ApiService apiService) async {
  // 저장된 토큰을 가져와 유효성 검사
  String? token = await apiService.getToken();
  if (token == null) {
    return false; // 토큰이 없으면 로그인 필요
  }

  // 토큰 만료 여부 확인
  bool isExpired = await apiService.isTokenExpired();
  if (isExpired) {
    // 토큰이 만료된 경우 로그인 필요
    return false;
  } else {
    // 토큰이 유효한 경우
    return true;
  }
}
