import 'package:concon/screen/coupon/my_coupon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:concon/screen/on_boarding/sign_in.dart';
import 'package:concon/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  // ApiService 인스턴스 생성
  final ApiService apiService = ApiService();

  // 자동 로그인 체크
  bool isLoggedIn = await checkAutoLogin(apiService);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFFF9900),
          selectionHandleColor: Color(0xFFFF9900),
        ),
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      home: isLoggedIn ? MyCouponList() : SignInPage(), // 초기 화면 설정
    );
  }
}

// 자동 로그인 여부 확인
Future<bool> checkAutoLogin(ApiService apiService) async {
  // 저장된 이메일과 비밀번호 가져오기
  String? email = await apiService.storage.read(key: 'savedEmail');
  String? password = await apiService.storage.read(key: 'savedPassword');

  if (email != null && password != null) {
    // 토큰 만료 여부 확인
    if (await apiService.isTokenExpired()) {
      print("토큰 만료");
      // 토큰이 만료되었으면 자동으로 로그인 시도
      final result = await apiService.autoLogin(email, password);
      return result.containsKey('token'); // 자동 로그인 성공 여부 반환
    } else {
      // 토큰이 유효한 경우 그대로 로그인 유지
      print('토큰 유효');
      String? token = await apiService.getToken();
      print(token);
      return true;
    }
  }

  // 이메일 또는 비밀번호가 없으면 로그인 필요
  print('저장된 이메일 및 비밀번호 부재');
  return false;
}
