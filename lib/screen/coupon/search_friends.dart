import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../api_service.dart';
import '../popup_widget.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  final ApiService apiService = ApiService();
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> searchResults = [];
  String searchQuery = '';
  bool isLoading = false;
  String? myUserId; // 내 userId 저장

  @override
  void initState() {
    super.initState();
    _loadMyUserId(); // 내 userId 불러오기
  }

  // 내 userId를 불러오는 함수
  Future<void> _loadMyUserId() async {
    myUserId = await storage.read(key: 'userId');
    print("내 아이디: $myUserId");
  }

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
            onPressed: () async {
              if (searchQuery.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });

                List<Map<String, dynamic>>? results =
                    await apiService.searchUsers(searchQuery);

                setState(() {
                  isLoading = false;
                  if (results != null) {
                    searchResults = results; // 검색 결과 업데이트
                  }
                });
              }
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : searchQuery.isEmpty
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

        // 내 userId와 일치하는 항목을 제외
        if (result['userId'].toString() == myUserId) {
          return SizedBox.shrink(); // 내 userId인 경우, 항목 숨김
        }

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
                radius: 30,
                backgroundImage: result['profileUrl'] != null &&
                        result['profileUrl'].isNotEmpty
                    ? NetworkImage(result['profileUrl']) as ImageProvider
                    : AssetImage('assets/imgs/user_image_sample.png'),
              ),
              title: Text(
                result['name'] ?? 'Unknown',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFFAF04),
                ),
              ),
              subtitle: Text(
                '#${result['userId'].toString().padLeft(7, '0')}',
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
                  print('이름: ${result['name']}\n번호: ${result['userId']}');
                  _showFriendRequestDialog(context, result['name'], int.parse(result['userId']));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // 친구 요청 확인 다이얼로그
void _showFriendRequestDialog(BuildContext context, String name, int userId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return ChoicePopupWidget(
        message: '$name님에게 \n친구 신청을 진행하시겠어요?',
        onConfirm: () async {

          try {
            // 친구 요청 보내기
            bool success = await _sendFriendRequest(userId);

            if (!mounted) return; // 위젯이 여전히 활성화 상태인지 확인

            // 친구 요청 성공 시 검색 화면을 닫고 FriendsList로 true 반환
            if (success) {
              print('친구 요청 성공');
            } else {
              // 이미 친구 요청이 진행 중일 때 알림 팝업
              showDialog(
                context: context,
                builder: (BuildContext innerDialogContext) {
                  return SimpleAlertPopupWidget(
                    message: '이미 친구 요청이 진행 중입니다.',
                  );
                },
              );
            }
          } catch (e) {
            print('Error during friend request: $e');
          }
        },
      );
    },
  );
}


  // 친구 요청 API 호출
Future<bool> _sendFriendRequest(int friendId) async {
  try {
    final response = await apiService.sendFriendRequest(friendId);
    if (response != null && response.statusCode == 200) {
      Navigator.pop(context, true); // 친구 요청 성공 시 true 반환하며 pop
      return true; // 요청 성공
    } else {
      return false; // 요청 실패 (이미 친구 요청 중)
    }
  } catch (e) {
    print('Error sending friend request: $e');
    return false; // 요청 실패
  }
}

}
