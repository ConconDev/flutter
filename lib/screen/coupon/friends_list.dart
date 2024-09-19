import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api_service.dart';
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
  List<Map<String, dynamic>> friendRequests = [];
  bool hasFriendRequests = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final friendsList = await apiService.getFriendsList();
      final requestsList = await apiService.getSentFriendRequests();
      final incomingRequests = await apiService.getFriendRequests();

      if (!mounted) return;

      setState(() {
        friends = friendsList ?? [];
        sentFriendRequests = requestsList ?? [];
        friendRequests = incomingRequests ?? [];
        hasFriendRequests = friendRequests.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      print("데이터를 불러오는 중 오류 발생: $e");

      if (mounted) {
        setState(() {
          isLoading = false;
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
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                hasFriendRequests ? Icons.notifications : Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFriends(),
                ),
              );
              if (result == true) {
                _loadAllData(); // 데이터 새로고침
              }
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      endDrawer: NotificationDrawer(
        notifications: friendRequests.map((request) {
          return {
            'title': '친구 신청',
            'message': '${request['name']}님이 친구 요청을 보냈습니다.',
          };
        }).toList(),
        onAccept: (index) async {
          final request = friendRequests[index];
          await apiService.acceptFriendRequest(request['friendshipId']);
          setState(() {
            friendRequests.removeAt(index);
          });
          Scaffold.of(context).closeEndDrawer();
          _loadAllData();
        },
        onReject: (index) async {
          final request = friendRequests[index];
          await apiService.denyFriendRequest(request['friendshipId']);
          setState(() {
            friendRequests.removeAt(index);
          });
          Scaffold.of(context).closeEndDrawer();
          _loadAllData();
        },
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChoicePopupWidget(
                          onConfirm: () async {
                            await _cancelFriendRequest(friend['friendshipId']);
                            _loadAllData();
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


class NotificationDrawer extends StatelessWidget {
  final List<Map<String, String>> notifications;
  final Function(int) onAccept;
  final Function(int) onReject;

  const NotificationDrawer({
    Key? key,
    required this.notifications,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '알림',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xff404040),
              ),
            ),
          ),
          Divider(
            color: Color(0xffd2d2d2),
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
          notifications.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off, size: 100, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '알림 메시지가 없습니다',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(0xff797979),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xffa0a0a0),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              notification['message']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xff5a5a5a),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        foregroundColor: Colors.grey,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Color(0xff5a5a5a)),
                                        minimumSize: Size(0, 33)),
                                    onPressed: () => onReject(index),
                                    child: Text(
                                      '거절',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff5a5a5a),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      foregroundColor: Colors.grey,
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Color(0xff5a5a5a)),
                                      minimumSize: Size(0, 33),
                                    ),
                                    onPressed: () => onAccept(index),
                                    child: Text(
                                      '승인',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff5a5a5a),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Color(0xffd2d2d2),
                              thickness: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}