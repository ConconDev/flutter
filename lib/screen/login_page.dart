import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFFB310),
                  Color(0xffFFCC5F),
                  Color(0xffFFFDF7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Image.asset(
                    'lib/assets/login_logo.png',
                    width: 300,
                    height: 270,
                  ),
                ),
                SizedBox(
                  //카카오톡 로그인 elevatedButton
                  width: 322,
                  height: 52,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(3),
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xffFDDC3F)),
                    ),
                    onPressed: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'lib/assets/kakao_icon.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Center(
                          child: Text(
                            "카카오 계정으로 로그인",
                            style: TextStyle(
                              color: Color(0xff3A2929),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: Container(),
                ),
                SizedBox(
                  //네이버 로그인 elevatedButton
                  width: 322,
                  height: 52,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(3),
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff03C75A)),
                      iconColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'lib/assets/naver_icon.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Center(
                          child: Text(
                            "네이버 계정으로 로그인",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: Container(),
                ),
                SizedBox(
                  //구글 로그인 elevatedButton
                  width: 322,
                  height: 52,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(3),
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff5186F7)),
                    ),
                    onPressed: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'lib/assets/google_icon.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                        Center(
                          child: Text(
                            " 구글 계정으로 로그인",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                  child: Container(),
                ),
                SizedBox(
                  //애플 로그인 elevatedButton
                  width: 322,
                  height: 52,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(3),
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                    ),
                    onPressed: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'lib/assets/apple_icon.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Center(
                          child: Text(
                            " 애플 계정으로 로그인",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
