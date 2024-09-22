import 'package:flutter/material.dart';
import 'package:concon/api_service.dart';
import '../popup_widget.dart';
import '../textfield_widget.dart';
import 'sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleAlertPopupWidget(message: message);  // 팝업으로 오류 메시지를 띄움
      },
    );
  }

  // 이메일 유효성 검사
  bool _validateEmail() {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailController.text.isEmpty) {
      _showPopup('이메일을 입력해주세요.');
      return false;
    } else if (!emailRegExp.hasMatch(emailController.text)) {
      _showPopup('유효한 이메일을 입력해주세요.');
      return false;
    }
    return true;
  }

  // 비밀번호 유효성 검사
  bool _validatePassword() {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (passwordController.text.isEmpty) {
      _showPopup('비밀번호를 입력해주세요.');
      return false;
    } else if (!passwordRegExp.hasMatch(passwordController.text)) {
      _showPopup('비밀번호는 최소 8자, 하나 이상의\n문자 및 숫자를 포함해야 합니다.');
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      _showPopup('비밀번호가 일치하지 않습니다.');
      return false;
    }
    return true;
  }

  Future<void> _signUp() async {
    // 유효성 검사 실패 시 API 호출 막음
    if (!_validateEmail() || !_validatePassword()) return;

    // API 호출
    final result = await apiService.signUp(emailController.text, passwordController.text);

    if (result.containsKey('error')) {
      _showPopup(result['error']);
    } else {
      _showPopup('회원가입이 완료되었습니다!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
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
                            text: "회원가입하고 콘콘과 함께\n",
                          ),
                          TextSpan(
                            text: "기프티콘 관리해보세요",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                            SignTextField(
                              controller: confirmPasswordController,
                              hintText: '비밀번호 확인',
                              isPassword: true,
                              isPasswordVisible: _isConfirmPasswordVisible,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFFFF9900),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                '회원 가입',
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
                        SizedBox(width: 15),
                        Text(
                          "간편 회원가입",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9900),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: 80,
                          child: Divider(
                            height: 1,
                            color: Color(0xFFFF9900),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    buildSocialSignUpOptions(),
                    SizedBox(height: 35),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: '이미 회원이신가요? ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFF9900),
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: '로그인하기',
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

  Widget buildSocialSignUpOptions() {
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
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요');
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
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요');
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
            _showPopup('현재 간편 회원가입이 지원되지 않습니다\n이메일로 진행해 주세요');
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
