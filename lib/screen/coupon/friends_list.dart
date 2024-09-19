import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api_service.dart'; // 수정된 import 경로
import '../popup_widget.dart';
import 'search_friends.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final ApiService apiService = ApiService();
  final storage = FlutterSecureStorage();

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> sentFriendRequests = [];
  bool hasFriendRequests = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData(); // 모든 API 호출을 관리하는 함수
  }

    // 모든 데이터를 불러오는 함수
  Future<void> _loadAllData() async {
    if (!mounted) return; // mounted 상태 확인

    setState(() {
      isLoading = true;
    });

    try {
      // 친구 목록, 내가 보낸 친구 요청, 나에게 온 친구 요청을 모두 불러옴
      final friendsList = await apiService.getFriendsList();
      final requestsList = await apiService.getSentFriendRequests();
      final incomingRequests = await apiService.getFriendRequests();

      if (!mounted) return; // setState 전에 다시 mounted 상태 확인

      setState(() {
        friends = friendsList ?? [];
        sentFriendRequests = requestsList ?? [];
        hasFriendRequests = (incomingRequests != null && incomingRequests.isNotEmpty);
        isLoading = false;
      });
    } catch (e) {
      print("데이터를 불러오는 중 오류 발생: $e");

      if (mounted) {
        setState(() {
          isLoading = false; // 에러 발생 시에도 로딩 상태 해제
        });
      }
    }
  }


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
            icon: Icon(
              hasFriendRequests ? Icons.notifications : Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {
              // 친구 요청 알림 처리
            },
          ),
          IconButton(
  icon: Icon(Icons.search, color: Colors.white),
  onPressed: () async {
    // 검색 화면으로 이동하고, pop 이후에 데이터 새로고침
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFriends(),
      ),
    );

    // 검색 화면에서 돌아온 경우에만 새로고침
    if (result == true) {
      _loadAllData(); // 데이터 새로고침
    }
  },
),
          SizedBox(width: 10),
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
                  color: Colors.white, // 흰색 컨테이너 유지
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.zero,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      )
                    : _buildFriendsListBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 친구 목록과 친구 요청 목록을 표시하는 위젯
  Widget _buildFriendsListBody() {
    return friends.isEmpty && sentFriendRequests.isEmpty
        ? _buildNoFriendsView()
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 15),
            children: [
              ...friends.map((friend) => _buildFriendTile(friend)).toList(),
              if (sentFriendRequests.isNotEmpty) ...[
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    '--- 친구 요청 진행 목록 ---',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ...sentFriendRequests
                    .map((request) => _buildFriendTile(request, isRequest: true))
                    .toList(),
              ],
            ],
          );
  }


  // 친구 목록 아이템을 그리는 위젯
  Widget _buildFriendTile(Map<String, dynamic> friend, {bool isRequest = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isRequest ? Color(0xFFFFEFCD) : Color(0xFFFFAF04),
              isRequest ? Color(0xFFFFE099) : Color(0xFFFFBF2D),
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          leading: CircleAvatar(
            backgroundImage: friend['profileUrl'] != null && friend['profileUrl'].isNotEmpty
                ? NetworkImage(friend['profileUrl']) as ImageProvider
                : AssetImage('assets/imgs/user_image_sample.png'),
            radius: 30,
          ),
          title: Text(
            friend['name'] ?? 'Unknown',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isRequest ? Colors.orange : Colors.white,
            ),
          ),
          subtitle: Text(
            '요청번호 ${friend['friendshipId'].toString().padLeft(5, '0')}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: isRequest ? Colors.orange : Colors.white,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: isRequest ? Colors.orange : Colors.white,
              size: 35,
            ),
            onPressed: isRequest
                ? () {
                    // 친구 요청 취소 확인 팝업
                    showDialog(
  context: context,
  builder: (BuildContext context) {
    return ChoicePopupWidget(
      onConfirm: () async {
        print("팝업에서 확인 버튼 눌림");  // 이 print가 호출되는지 확인
        await _cancelFriendRequest(friend['friendshipId']);

        _loadAllData(); // API 호출 후 목록 갱신
      },
      message: '${friend['name']}님께 신청한\n친구 요청을 취소하시겠습니까?',
    );
  },
);
                  }
                : null,
          ),
        ),
      ),
    );
  }


  // 친구 요청 취소 API 호출 함수
  Future<void> _cancelFriendRequest(int friendshipId) async {
    try {
      final response = await apiService.cancelFriendRequest(friendshipId);
      if (response != null && response.statusCode == 200) {
        print("친구 요청 취소 성공");
      } else {
        print("친구 요청 취소 실패");
      }
    } catch (e) {
      print("친구 요청 취소 중 오류 발생: $e");
    }
  }


  // 친구가 없을 때 표시할 화면
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
