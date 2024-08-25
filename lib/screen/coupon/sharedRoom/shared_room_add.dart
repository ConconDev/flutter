import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../popup_widget.dart';

class SharedRoomAdd extends StatefulWidget {
  final String? roomName;
  final List<Map<String, String>>? existingMembers;
  final String? roomImage;

  const SharedRoomAdd({super.key, this.roomName, this.existingMembers, this.roomImage});

  @override
  _SharedRoomAddState createState() => _SharedRoomAddState();
}

class _SharedRoomAddState extends State<SharedRoomAdd> {
  List<Map<String, String>> members = [];
  String roomName = '';
  XFile? _imageFile;

  final List<Map<String, String>> friendList = [
    {'username': 'Mia', 'image': 'assets/imgs/sample1.jpg'},
    {'username': 'Seeyaa', 'image': 'assets/imgs/sample2.jpg'},
    {'username': 'dffdf', 'image': 'assets/imgs/sample3.jpg'},
    {'username': 'NN', 'image': 'assets/imgs/sample4.jpg'},
    {'username': 'nyuo', 'image': 'assets/imgs/sample5.jpg'},
  ];

  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
void initState() {
  super.initState();
  if (widget.existingMembers != null) {
    members = widget.existingMembers!;
  }
  if (widget.roomName != null) {
    roomName = widget.roomName!;
  }
  // widget.roomImage를 바로 사용하고, 변환하는 부분은 제거
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
            '공유방 추가',
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 18,
                      right: 18,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFFC95A),
                              Color(0xFFFFD883),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildRoomImagePicker(),
                            SizedBox(height: 20),
                            _buildRoomNameField(),
                            SizedBox(height: 10),
                            _buildMemberList(),
                            SizedBox(height: 8),
                            _buildMemberDropdown(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 18,
                      right: 18,
                      child: _buildCompleteButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildRoomImagePicker() {
  return GestureDetector(
    onTap: () async {
      // 갤러리에서 이미지 선택
      final XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        setState(() {
          _imageFile = selectedImage;
        });
      }
    },
    child: Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: _imageFile != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(_imageFile!.path),
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            )
          : widget.roomImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.roomImage!, // 전달받은 경로를 바로 사용
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                )
              : Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.grey[800],
                ),
    ),
  );
}


  Widget _buildRoomNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: TextEditingController(text: roomName),
          decoration: InputDecoration(
            hintText: '공유방 이름을 입력해주세요',
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          onChanged: (value) {
            setState(() {
              roomName = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return members.isEmpty
        ? SizedBox.shrink()
        : SizedBox(
            height: 120,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(members[index]['image']!),
                            radius: 40,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  members.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        members[index]['username']!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget _buildMemberDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            '공유방 멤버 추가하기',
            style: TextStyle(color: Color(0xFF484848)),
          ),
          icon:
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF484848)),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              // 기존 멤버 확인
              final isExistingMember =
                  members.any((member) => member['username'] == value);

              if (isExistingMember) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleAlertPopupWidget(
                      message: '이미 추가된 멤버입니다\n다른 멤버를 선택해주세요',
                    );
                  },
                );
              } else {
                final selectedFriend = friendList
                    .firstWhere((friend) => friend['username'] == value);
                members.add(selectedFriend);

                // 새로 추가된 항목으로 스크롤
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              }
            });
          },
          items: friendList.map((friend) {
            return DropdownMenuItem<String>(
              value: friend['username'],
              child: Text(
                friend['username']!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF484848),
                ),
              ),
            );
          }).toList(),
          dropdownColor: Colors.white,
          style: TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFF484848),
          ),
          selectedItemBuilder: (BuildContext context) {
            return friendList.map<Widget>((friend) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  friend['username']!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF484848),
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return ElevatedButton(
      onPressed: () {
        // 공유방 생성/수정 로직
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF8A00),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(double.infinity, 50),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
      child: Text(
        '완료',
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
