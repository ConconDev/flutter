import 'dart:io';
import 'package:concon/screen/setting/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../navigation_bar.dart';
import '../on_boarding/sign_in.dart';
import '../popup_widget.dart';
import 'package:concon/api_service.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 40.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: value ? Color(0xFF484848) : Color(0xFFCBCBCB),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeIn,
              top: 2.0,
              left: value ? 20.0 : 2.0,
              right: value ? 2.0 : 20.0,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final ApiService apiService = ApiService();

  File? _imageFile;
  String _nickname = 'User';
  Color _avatarColor = Colors.grey;
  bool _locationAlert = false;
  bool _expirationAlert = false;
  final bool _isVerified = false;

  late TextEditingController _nicknameController;
  late TextEditingController _expirationPeriodController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    _nicknameController = TextEditingController(text: _nickname);
    _expirationPeriodController = TextEditingController(text: '7');
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _nicknameController.dispose();
    _expirationPeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '내 계정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChoicePopupWidget(
                    message: "로그아웃 시 로그인 화면으로 돌아갑니다\n로그아웃을 진행하시겠습니까?",
                    onConfirm: () async {
  bool success = await apiService.logout();
  if (!mounted) return;

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  } else {
    _showPopup('로그아웃에 실패했습니다.', false);
  }
},

                  );
                },
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignOut()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFAF04),
                Color(0xFFFFE895),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight * 2.2),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  _imageFile = File(pickedFile.path);
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(112.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 5,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 112.5,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : null,
                                    child: _imageFile == null
                                        ? Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.grey[800],
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 3,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildSectionWithEditableField(
                          title: '닉네임',
                          controller: _nicknameController,
                          onChanged: (value) {
                            setState(() {
                              _nickname = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        _buildSectionWithColorPicker(),
                        SizedBox(height: 30),
                        _buildNotificationSettings(),
                        SizedBox(height: 30),
                        _buildVerificationSection(),
                        SizedBox(height: 40),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 유저 데이터 수정 API 연결
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF8A00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Text(
                                  '수정하기',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildSectionWithEditableField({
    required String title,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Row(
      children: [
        _buildTitleWithVerticalLine(title),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
            ],
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF484848),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWithColorPicker() {
    return Row(
      children: [
        _buildTitleWithVerticalLine('아바타 색상 설정'),
        SizedBox(width: 15),
        GestureDetector(
          onTap: () {
            _showColorPicker();
          },
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _avatarColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleWithVerticalLine(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF484848),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 2,
          height: 15,
          color: Color(0xFF484848),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기프티콘 알림 설정',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF484848),
          ),
        ),
        SizedBox(height: 20),
        _buildToggleWithLine(
          title: '위치 기준 브랜드 알림 여부',
          value: _locationAlert,
          onChanged: (value) {
            setState(() {
              _locationAlert = value;
            });
          },
        ),
        SizedBox(height: 20),
        _buildToggleWithLine(
          title: '유효기간 기준 알림 여부',
          value: _expirationAlert,
          onChanged: (value) {
            setState(() {
              _expirationAlert = value;
            });
          },
        ),
        SizedBox(height: 20),
        buildTextFieldWithLine(
          title: '유효기간 알림 기간 설정',
          enabled: _expirationAlert,
          hintText: '7',
          controller: _expirationPeriodController,
          onChanged: (value) {
            setState(() {
            });
          },
        ),
      ],
    );
  }

  Widget buildTextFieldWithLine({
    required String title,
    required bool enabled,
    required String hintText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal, // regular
                fontSize: 16,
                color: enabled ? Color(0xFF484848) : Color(0xFFA0A0A0),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 2,
              height: 15,
              color: enabled ? Color(0xFF484848) : Color(0xFFA0A0A0),
            ),
          ],
        ),
        enabled
            ? Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 19,
                    child: TextField(
                      textAlign: TextAlign.end,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF484848),
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                  Text(
                    '일',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF484848),
                    ),
                  ),
                ],
              )
            : Container(), // 활성화되지 않은 경우
      ],
    );
  }

  Widget _buildToggleWithLine({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Color(0xFF484848),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 2,
              height: 15,
              color: Color(0xFF484848),
            ),
          ],
        ),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildTitleWithVerticalLine('본인인증'),
            SizedBox(width: 15),
            Text(
              _isVerified ? '인증 완료' : '미인증',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _isVerified ? Colors.black : Color(0xFF6D6D6D),
              ),
            ),
          ],
        ),
        if (!_isVerified)
          Row(
            children: [
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  // 본인인증 API 연결
                },
                child: Row(
                  children: [
                    Text(
                      '본인인증 하기',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _avatarColor,
                onColorChanged: (color) {
                  setState(() {
                    _avatarColor = color;
                  });
                },
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF484848),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  // 팝업 메시지 표시
  void _showPopup(String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message, success: success);
      },
    );
  }
}
