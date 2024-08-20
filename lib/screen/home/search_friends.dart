import 'package:flutter/material.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  List<Map<String, String>> searchResults = [
    {
      'username': 'seeya00_',
      'userId': '#0000002',
      'image': 'assets/imgs/sample5.jpg'
    },
    {
      'username': 'seeya',
      'userId': '#0000001',
      'image': 'assets/imgs/sample6.jpg'
    },
    {
      'username': 'seeyaa',
      'userId': '#0000032',
      'image': 'assets/imgs/sample7.jpg'
    },
    {
      'username': 'seeya01',
      'userId': '#0000021',
      'image': 'assets/imgs/sample8.jpg'
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색하고자 하는 유저명을 입력하세요',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                  // 여기에 서버에서 검색 결과를 받아오는 로직 추가 가능
                });
              },
            ),
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
              // 검색 동작 실행
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
            end: Alignment.bottomRight,
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
              child: searchQuery.isEmpty
                  ? _buildInitialSearchView()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialSearchView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            '검색된 유저가 없습니다',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '상단 입력창에 유저명을 입력해\n원하는 유저를 추가해 보세요',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              leading: CircleAvatar(
                backgroundImage: AssetImage(result['image']!),
                radius: 30,
              ),
              title: Text(
                result['username']!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFFAF04),
                ),
              ),
              subtitle: Text(
                result['userId']!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xffFFAF04),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Color(0xffFFAF04),
                  size: 35,
                ),
                onPressed: () {
                  // 친구 추가하기 동작
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
