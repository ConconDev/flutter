import 'package:concon/screen/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'shared_room_add.dart'; // 공유방 추가/수정 화면

class SharedRoomDetail extends StatefulWidget {
  final Map<String, String> room;

  const SharedRoomDetail({super.key, required this.room});

  @override
  State<SharedRoomDetail> createState() => _SharedRoomDetailState();
}

class _SharedRoomDetailState extends State<SharedRoomDetail> {
  String _selectedSortOption = '만료일자순';

  final List<Map<String, String>> gifticons = [
    {
      'title': '따뜻한 카페라테 커플세트',
      'image': 'assets/imgs/cafe_sample1.png',
      'expiration': '2024년 4월 8일',
      'price': '14,000원',
      'category': '카페 음료',
      'brand': '스타벅스',
    },
    {
      'title': '아메리카노',
      'image': 'assets/imgs/cafe_sample2.png',
      'expiration': '2024년 4월 9일',
      'price': '4,500원',
      'category': '카페 음료',
      'brand': '스타벅스',
    },
    {
      'title': '카페모카',
      'image': 'assets/imgs/cafe_sample3.png',
      'expiration': '2024년 5월 10일',
      'price': '5,000원',
      'category': '카페 음료',
      'brand': '이디야커피',
    },
    {
      'title': '아메리카노',
      'image': 'assets/imgs/cafe_sample4.png',
      'expiration': '2024년 6월 1일',
      'price': '4,800원',
      'category': '카페 음료',
      'brand': '스타벅스',
    },
  ];

  final List<Map<String, String>> members = [
    {'username': 'Mia', 'image': 'assets/imgs/sample1.jpg'},
    {'username': '엄마', 'image': 'assets/imgs/sample2.jpg'},
    {'username': '아빠', 'image': 'assets/imgs/sample3.jpg'},
    {'username': '동생', 'image': 'assets/imgs/sample4.jpg'},
    {'username': 'Mia', 'image': 'assets/imgs/sample1.jpg'},
    {'username': '엄마', 'image': 'assets/imgs/sample2.jpg'},
    {'username': '아빠', 'image': 'assets/imgs/sample3.jpg'},
    {'username': '동생', 'image': 'assets/imgs/sample4.jpg'},
    // 필요에 따라 더 많은 멤버 추가 가능
  ];

  void _sortGifticonList() {
    setState(() {
      if (_selectedSortOption == '만료일자순') {
        gifticons.sort((a, b) {
          DateTime dateA = DateFormat('yyyy년 M월 d일').parse(a['expiration']!);
          DateTime dateB = DateFormat('yyyy년 M월 d일').parse(b['expiration']!);
          return dateA.compareTo(dateB);
        });
      } else if (_selectedSortOption == '높은금액순') {
        gifticons.sort((a, b) {
          int priceA = int.parse(a['price']!.replaceAll(RegExp(r'[^\d]'), ''));
          int priceB = int.parse(b['price']!.replaceAll(RegExp(r'[^\d]'), ''));
          return priceB.compareTo(priceA);
        });
      } else if (_selectedSortOption == '낮은금액순') {
        gifticons.sort((a, b) {
          int priceA = int.parse(a['price']!.replaceAll(RegExp(r'[^\d]'), ''));
          int priceB = int.parse(b['price']!.replaceAll(RegExp(r'[^\d]'), ''));
          return priceA.compareTo(priceB);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '공유방 상세',
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
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoomHeader(),
                        _buildGifticonList(),
                        _buildBottomButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 400,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(widget.room['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.room['title']!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF484848),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '참여 인원: ${widget.room['members']}\n기프티콘 개수: ${gifticons.length}개',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildMemberList(),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '기프티콘 목록',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF484848),
                ),
              ),
              DropdownButton<String>(
                value: _selectedSortOption,
                icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF484848)),
                dropdownColor: Colors.white,
                items: <String>['만료일자순', '높은금액순', '낮은금액순'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF484848),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSortOption = newValue!;
                    _sortGifticonList();
                  });
                },
                underline: SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(member['image']!),
                    radius: 25,
                  ),
                  SizedBox(height: 5),
                  Text(
                    member['username']!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF484848),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGifticonList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 10),
      itemCount: gifticons.length,
      itemBuilder: (context, index) {
        return _buildGifticonTile(gifticons[index]);
      },
    );
  }

  Widget _buildGifticonTile(Map<String, String> gifticon) {
    return InkWell(
      onTap: () {
        // 기프티콘 원본 사진 보여주는 팝업 구현
      print("Gifticon tapped: ${gifticon['title']}");
    },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, 3),
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
                        gifticon['image']!,
                        width: 124,
                        height: 124,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gifticon['brand']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF484848),
                              ),
                            ),
                            Text(
                              gifticon['title']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF484848),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '유효 기간:',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                                Text(
                                  gifticon['expiration']!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '금액:',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                                Text(
                                  gifticon['price']!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '카테고리:',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                                Text(
                                  gifticon['category']!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF484848),
                  size: 20,
                ),
                onPressed: () {
                  ChoicePopupWidget(
                    message: '이 기프티콘을 공유방에서 삭제하시겠습니까?\n삭제된 기프티콘은 복구가 불가능합니다',
                    onConfirm: () {
                      print("기프티콘 삭제");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildShadowedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharedRoomAdd(
                          roomName: widget.room['title'],
                          existingMembers: members,
                          roomImage: widget.room['image'],
                        ),
                      ),
                    );
                  },
                  backgroundColor: Color(0xFFFF8A00),
                  text: '공유방 수정',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildShadowedButton(
                  onPressed: () {
                    // 기프티콘 추가 화면 연결
                  },
                  backgroundColor: Color(0xFFFFB800),
                  text: '기프티콘 추가',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShadowedButton({
    required VoidCallback onPressed,
    required Color backgroundColor,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
