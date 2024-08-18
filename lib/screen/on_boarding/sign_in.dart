import 'package:concon/screen/on_boarding/sign_up.dart';
import 'package:flutter/material.dart';
import '../popup_widget.dart';
import '../textfield_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool _isPasswordVisible = false;

  void _showPopup(String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message, success: success);
      },
    );
  }

  String? _validateEmail(String? value) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    } else if (!emailRegExp.hasMatch(value)) {
      return '유효한 이메일을 입력해주세요.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    } else if (!passwordRegExp.hasMatch(value)) {
      return '비밀번호는 최소 8자, 하나 이상의 문자 및 숫자를 포함해야 합니다.';
    }
    return null;
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
                              validator: _validateEmail,
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
                              validator: _validatePassword,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_validateEmail(emailController.text) !=
                                        null ||
                                    _validatePassword(
                                            passwordController.text) !=
                                        null) {
                                  _showPopup('로그인에 실패했습니다\n가입 여부 및 이메일, 비밀번호를\n다시 한 번 확인해주세요', false);
                                } else {
                                  _showPopup(
                                      '${emailController.text} 계정으로\n로그인에 성공했습니다',
                                      true);
                                }
                              },
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
                    ), SizedBox(height: 60,)
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
        },constraints: BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
      SizedBox(width: 25),
      IconButton(
        icon: Image.asset('assets/icon/google_icon.png'),
        iconSize: 45,
        onPressed: () {
          print('Google Button');
          // 구글 로그인
        },constraints: BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ],
  );
}

}
