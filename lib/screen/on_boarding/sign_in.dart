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

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  // 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    if (isChecked) { // 앱을 켰을 때 체크박스 상태를 확인하여 자동 로그인 시도
      String? email = await apiService.storage.read(key: 'savedEmail');
      String? password = await apiService.storage.read(key: 'savedPassword');
      
      if (email != null && password != null) {
        final result = await apiService.autoLogin(email, password);
        if (result.containsKey('token')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyCouponList()),
          );
        } else {
          _showPopup('자동 로그인에 실패했습니다. 다시 로그인해주세요.', false);
        }
      }
    }
  }

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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final result = await apiService.login(emailController.text, passwordController.text);

      if (result.containsKey('error')) {
        _showPopup(result['error'], false);
      } else {
        _showPopup('로그인에 성공했습니다!', true);
        if (isChecked) {
          // 로그인 상태 유지 체크 시 이메일과 비밀번호 저장
          await apiService.storage.write(key: 'savedEmail', value: emailController.text);
          await apiService.storage.write(key: 'savedPassword', value: passwordController.text);
        }
        
      }
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
          },
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
