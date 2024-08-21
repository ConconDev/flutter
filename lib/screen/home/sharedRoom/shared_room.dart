import 'package:flutter/material.dart';
import '../../popup_widget.dart';
import 'shared_room_add.dart';
import 'shared_room_detailed.dart';

class SharedRoom extends StatelessWidget {
  final List<Map<String, String>> sharedRooms = [
    {
      'title': '가족 기프티콘',
      'image': 'assets/imgs/sample1.jpg',
      'members': '4명',
      'gifts': '15개'
    },
    {
      'title': '술쟁이들',
      'image': 'assets/imgs/sample2.jpg',
      'members': '4명',
      'gifts': '15개'
    },
    {
      'title': '대학 동기',
      'image': 'assets/imgs/sample3.jpg',
      'members': '10명',
      'gifts': '30개'
    },
    {
      'title': 'A사 직원 모임',
      'image': 'assets/imgs/sample4.jpg',
      'members': '15명',
      'gifts': '152개'
    },
  ];

  SharedRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '공유방',
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: sharedRooms.isEmpty
                    ? _buildNoSharedRoomsUI(context)
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        itemCount: sharedRooms.length + 1,
                        itemBuilder: (context, index) {
                          if (index == sharedRooms.length) {
                            return _buildAddButton(context);
                          }
                          return _buildSharedRoomTile(
                              context, sharedRooms[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSharedRoomsUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [SizedBox(height: 100,),
        Column(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 150,
              color: Color(0xFFFF8A00),
            ), SizedBox(height: 20),
        Text(
          '공유방이 없습니다',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF8A00),
          ),
        ),
        SizedBox(height: 10),
        Text(
          '하단의 추가하기 버튼을 눌러\n기프티콘을 함께 사용해보세요',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFFFF8A00),
          ),
        ),
          ],
        ),
        SizedBox(height: 40),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildSharedRoomTile(BuildContext context, Map<String, String> room) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharedRoomDetailed(room: room),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        room['image']!,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room['title']!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF484848),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '참여 인원: ${room['members']}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '기프티콘 개수: ${room['gifts']}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChoicePopupWidget(
                      onConfirm: () {
                        // 공유방에서 나가기 로직 구현
                      },
                      message: '공유방에서 나가시겠습니까?\n다른 멤버의 초대로 다시 들어갈 수 있습니다',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SharedRoomAdd(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF8A00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          '추가하기',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
