import 'package:flutter/material.dart';
import 'package:concon/api_service.dart';
import '../coupon/my_coupon_list.dart';
import '../popup_widget.dart';
import '../textfield_widget.dart';
import 'sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isChecked = false; // 로그인 상태 유지 체크박스
  bool _isPasswordVisible = false;

  // 유효성 검사를 먼저 처리
  bool _validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    // 이메일 또는 비밀번호가 유효하지 않으면 팝업을 띄움
    if (!emailRegExp.hasMatch(email) || !passwordRegExp.hasMatch(password)) {
      _showPopup(
        '이메일과 비밀번호 양식을 다시 확인해주세요\n비밀번호는 최소 8자, 하나 이상의\n문자 및 숫자를 포함해야 합니다',
        false,
      );
      return false;
    }
    return true;
  }

  void _showPopup(String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message, success: success);
      },
    );
  }

  // 로그인 시도
Future<void> _login() async {
  // 유효성 검사 실패 시 로그인 API 호출을 막음
  if (!_validateInputs()) return;

  final result = await apiService.login(emailController.text, passwordController.text);

  if (result.containsKey('error')) {
    final error = result['error'];
    print("Error: $error"); // 디버깅 추가

    if (error != null && error == 'Bad credentials') {
      // 'Bad credentials' 에러일 경우 팝업 표시
      _showPopup('이메일과 비밀번호가 틀렸습니다\n다시 확인해주세요.', false);
    } else {
      _showPopup(error ?? '알 수 없는 오류가 발생했습니다.', false);
    }
  } else if (result.containsKey('token')) {
    _showPopup('로그인에 성공했습니다!', false); // 성공 시 팝업
    if (isChecked) {
      // 로그인 상태 유지 체크 시 이메일과 비밀번호 저장
      await apiService.storage.write(key: 'savedEmail', value: emailController.text);
      await apiService.storage.write(key: 'savedPassword', value: passwordController.text);
    }
    // 로그인 성공 후 다른 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyCouponList()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFB311),
                    Color(0xFFFFCC5F),
                    Color(0xFFFEFBF1),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Image.asset(
                'assets/background_dots.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/concon.png',
                        width: 300,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "로그인을 통해 콘콘만의 새로운\n",
                          ),
                          TextSpan(
                            text: "기프티콘 통합 서비스를 ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "경험해보세요"),
                        ],
                      ),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF),
                        letterSpacing: -0.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SignTextField(
                              controller: emailController,
                              hintText: '이메일',
                              isPassword: false,
                              isPasswordVisible: false,
                            ),
                            SizedBox(height: 20),
                            SignTextField(
                              controller: passwordController,
                              hintText: '비밀번호',
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFFF9900),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Checkbox(
                            side: const BorderSide(
                              color: Color(0xFFFF9900),
                              width: 2,
                            ),
                            value: isChecked,
                            activeColor: Color(0xFFFF9900),
                            checkColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Text(
                            '로그인 상태 유지하기',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFFFF9900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Divider(
                            height: 1,
                            color: Color(0xFFFF9900),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "간편 로그인",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9900),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 80,
                          child: Divider(
                            height: 1,
                            color: Color(0xFFFF9900),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    buildSocialSignInOptions(),
                    SizedBox(height: 35),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: '회원이 아니신가요? ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFF9900),
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: '회원가입하기',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSocialSignInOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Image.asset('assets/icon/kakao_icon.png'),
          iconSize: 45,
          onPressed: () {
            print('Kakao Button');
            // 카카오 로그인
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요', false);
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
        SizedBox(width: 25),
        IconButton(
          icon: Image.asset('assets/icon/naver_icon.png'),
          iconSize: 45,
          onPressed: () {
            print('Naver Button');
            // 네이버 로그인
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요', false);
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
        SizedBox(width: 25),
        IconButton(
          icon: Image.asset('assets/icon/google_icon.png'),
          iconSize: 45,
          onPressed: () {
            print('Google Button');
            // 구글 로그인
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요', false);
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
