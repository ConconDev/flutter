import 'package:concon/screen/coupon/my_coupon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:concon/screen/on_boarding/sign_in.dart';
import 'package:concon/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  const MyApp({super.key, required this.isLoggedIn});

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
  // 저장된 토큰 가져오기
  String? token = await apiService.getToken();

  if (token != null) {
    // 토큰이 있는 경우, 만료 여부 확인
    if (await apiService.isTokenExpired()) {
      print("토큰 만료");
      // 토큰이 만료되었으면 이메일과 비밀번호로 자동 로그인 시도
      String? email = await apiService.storage.read(key: 'savedEmail');
      String? password = await apiService.storage.read(key: 'savedPassword');

      if (email != null && password != null) {
        final result = await apiService.autoLogin(email, password);
        return result.containsKey('token'); // 자동 로그인 성공 여부 반환
      } else {
        // 저장된 이메일과 비밀번호가 없으면 로그인이 필요함
        print('저장된 이메일 및 비밀번호 부재');
        return false;
      }
    } else {
      // 토큰이 유효한 경우 그대로 로그인 유지
      print('토큰 유효');
      return true;
    }
  } else {
    // 토큰이 없는 경우 로그인 필요
    print('저장된 토큰 없음, 로그인 페이지로 이동');
    return false;
  }
}
