import 'package:flutter/material.dart';

import '../popup_widget.dart';
import 'search_friends.dart'; // 새로 추가될 파일을 임포트

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<Map<String, String>> friends = [
    {
      'username': 'Mia',
      'userId': '#0000023',
      'image': 'assets/imgs/sample1.jpg'
    },
    {
      'username': 'Sujin',
      'userId': '#0000028',
      'image': 'assets/imgs/sample2.jpg'
    },
    {
      'username': 'NumberReal',
      'userId': '#0000055',
      'image': 'assets/imgs/sample3.jpg'
    },
    {
      'username': 'its_soyunn',
      'userId': '#0000020',
      'image': 'assets/imgs/sample4.jpg'
    },
    {
      'username': 'seeya00_',
      'userId': '#0000002',
      'image': 'assets/imgs/sample5.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '친구 목록',
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // 검색 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFriends(),
                ),
              );
            },
          ),
          SizedBox(
            width: 10,
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.zero,
                child: _buildFriendsListBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsListBody() {
    return friends.isEmpty
        ? _buildNoFriendsView()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 15),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return _buildFriendTile(friends[index]);
            },
          );
  }

  Widget _buildFriendTile(Map<String, String> friend) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFAF04),
              Color(0xFFFFBF2D),
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          leading: CircleAvatar(
            backgroundImage: AssetImage(friend['image']!),
            radius: 30,
          ),
          title: Text(
            friend['username']!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            friend['userId']!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              // 팝업창에서 삭제 여부를 확인
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChoicePopupWidget(
                    onConfirm: () {
                      setState(() {
                        // 친구 삭제 로직 구현
                      });
                      Navigator.of(context).pop();
                    },
                    message: '삭제 후에는 복구가 불가능합니다\n선택하신 친구를 삭제하시겠습니까?',
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoFriendsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 100,
            color: Colors.orange,
          ),
          SizedBox(height: 20),
          Text(
            '추가된 친구가 없습니다',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '우측 상단의 검색하기 버튼을 눌러\n친구를 검색하고 추가해보세요',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Color(0xffFFAF04),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
