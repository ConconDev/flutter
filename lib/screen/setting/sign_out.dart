import 'package:flutter/material.dart';
import '../on_boarding/sign_in.dart';
import '../popup_widget.dart';
import 'package:concon/api_service.dart'; // ApiService 추가

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService(); // ApiService 인스턴스 생성

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '회원 탈퇴',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF8A00),
              Color(0xFFFFE895),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                'assets/sign_out_background_dots.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: kToolbarHeight * 2.2),
                Text(
                  'CONCON의 계정을',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '정말 삭제하시겠어요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 30,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    '탈퇴를 진행하시는 경우\n계정과 관련된 모든 정보가 삭제되며\n이후 해당 계정으로는\n모든 서비스 접근이 불가합니다\n\n계속하시려면 아래의 탈퇴하기\n버튼을 눌러 진행해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                SizedBox(height: 270),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 탈퇴 API 연결
                        bool success = await apiService.deleteUser();
                        if (success) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleAlertPopupWidget(
                                message: '탈퇴가 완료되었습니다\n그동안 서비스를 이용해주셔서 감사합니다',
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          _showErrorPopup(context, '탈퇴에 실패했습니다. 다시 시도해주세요.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF8A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        '탈퇴하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 오류 팝업 메시지 표시
  void _showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message, success: false);
      },
    );
  }
}
