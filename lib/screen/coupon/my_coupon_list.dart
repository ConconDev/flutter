import 'package:concon/screen/coupon/friends_list.dart';
import 'package:concon/screen/coupon/sharedRoom/shared_room.dart';
import 'package:concon/screen/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api_service.dart';
import '../popup_widget.dart';
import 'detail/coupon_detail.dart';
import 'write_review.dart';

class MyCouponList extends StatefulWidget {
  const MyCouponList({super.key});

  @override
  State<MyCouponList> createState() => _MyCouponListState();
}

class _MyCouponListState extends State<MyCouponList> {
  final storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  final Uri openChatUrl = Uri.parse('https://open.kakao.com/o/sGxNJkKg');
  String dropDownValue = "유효기간순";
  String reviewSortValue = "날짜순";

  bool firstState = false;
  bool secondState = false;
  bool thirdState = true;
  late List<bool> isSelected;

  String userName = 'Unknown';
  String userId = '00000000';
  String profileImageUrl = 'assets/imgs/user_image_sample.png';

  // 내 기프티콘 데이터
  final List<Map<String, dynamic>> myCouponData = [
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024년 5월 7일',
      'price': '14,000원',
      'category': '카페 음료',
      'status': 'normal', // normal, purchased, used
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'date': '2024년 12월 21일',
      'price': '21,000원',
      'category': '카페 음료',
      'status': 'purchased',
    },
    {
      'image': 'assets/imgs/cafe_sample3.png',
      'brand': '이디야커피',
      'productName': '카페라테(ICE)',
      'date': '2024년 7월 11일',
      'price': '5,500원',
      'category': '카페 음료',
      'status': 'used',
    },
  ];

  // 판매 상품 데이터
  final List<Map<String, dynamic>> saleItemData = [
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024년 5월 7일',
      'price': '14,000원',
      'category': '카페 음료',
    },
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024년 5월 7일',
      'price': '14,000원',
      'category': '카페 음료',
      'status': 'sold', // sold, settled
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'date': '2024년 12월 21일',
      'price': '21,000원',
      'category': '카페 음료',
      'status': 'settled',
    },
  ];

  // 리뷰 목록 데이터
  final List<Map<String, dynamic>> reviewData = [
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024-01-04',
      'reviewText':
          '커플세트인데 혼자 두잔 다마셨어요 솔직히 다들 갑자기 라테 땡길때 있잖아요 근데 다른분들은 그냥 비싼걸로 시켜드세요 넘 배부른거',
      'rating': 4.0,
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'date': '2024-12-21',
      'reviewText':
          '저 케이크가 진짜 맛도리입니다 위에 올라간게 약간 느끼할줄알았는데 생각보다 괜찮았어요 근데 가격대비 별로인듯한? 그런 느낌이에요',
      'rating': 3.0,
    },
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024-05-07',
      'reviewText':
          '커플세트인데 혼자 두잔 다마셨어요 솔직히 다들 갑자기 라테 땡길때 있잖아요 근데 다른분들은 그냥 비싼걸로 시켜드세요 넘 배부른거',
      'rating': 2.5,
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'date': '2024-12-21',
      'reviewText':
          '저 케이크가 진짜 맛도리입니다 위에 올라간게 약간 느끼할줄알았는데 생각보다 괜찮았어요 근데 가격대비 별로인듯한? 그런 느낌이에요',
      'rating': 5.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // 회원 정보를 불러옴
    isSelected = [firstState, secondState, thirdState];
  }

// 회원 정보 불러오기 함수
  Future<void> _fetchUserInfo() async {
    final userInfo = await apiService.getUserInfo(); // 회원 정보 API 호출
    if (userInfo != null) {
      setState(() {
        userName = userInfo['username'] ?? 'Unknown User';
        userId = userInfo['userId'].toString().padLeft(7, '0'); // 7자리로 포맷
        profileImageUrl = userInfo['profileUrl'] != null && userInfo['profileUrl'].isNotEmpty
            ? userInfo['profileUrl'] // 프로필 이미지 URL
            : 'assets/imgs/user_image_sample.png'; // 기본 이미지
      });

      // userId를 안전한 저장소에 저장
      await storage.write(key: 'userId', value: userInfo['userId'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentData;

    if (firstState) {
      currentData = saleItemData;
      // 선택한 드롭다운 값에 따라 정렬 수행
      if (dropDownValue == '유효기간순') {
        currentData.sort((a, b) {
          DateFormat dateFormat = DateFormat('yyyy년 M월 d일');
          DateTime dateA = dateFormat.parse(a['date']);
          DateTime dateB = dateFormat.parse(b['date']);
          return dateA.compareTo(dateB);
        });
      } else if (dropDownValue == '높은금액순') {
        currentData.sort((a, b) =>
            int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), '')).compareTo(
              int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), '')),
            ));
      } else if (dropDownValue == '낮은금액순') {
        currentData.sort((a, b) =>
            int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), '')).compareTo(
              int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), '')),
            ));
      }
    } else if (secondState) {
      currentData = reviewData;
      reviewData.sort((a, b) {
        if (reviewSortValue == '날짜순') {
          return b['date'].compareTo(a['date']);
        } else if (reviewSortValue == '별점순') {
          return b['rating'].compareTo(a['rating']);
        }
        return 0;
      });
    } else {
      currentData = myCouponData;
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          Column(
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
  radius: 40,
  backgroundImage: profileImageUrl.startsWith('http')
      ? NetworkImage(profileImageUrl)
      : AssetImage(profileImageUrl) as ImageProvider,
  onBackgroundImageError: (exception, stackTrace) {
    setState(() {
      profileImageUrl = 'assets/imgs/user_image_sample.png'; // 기본 이미지로 대체
    });
  },
),

                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName, // 유저 이름
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#$userId', // 유저 ID
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: () {
                                  // 공유방 화면 전환
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SharedRoom(),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  Icons.group,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '공유방',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 17),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: () {
                                  // 친구 목록 화면 전환
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendsList(),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  Icons.folder_shared_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '친구 목록',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: () {
                                  // 깃허브 URL 공유
                                  Share.share('https://github.com/ConconDev');
                                },
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  Icons.share,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '공유하기',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 12, 20, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    firstState = true;
                                    secondState = false;
                                    thirdState = false;
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '판매 상품',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: firstState
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: firstState
                                            ? Color(0xFFFF9900)
                                            : Color(0xFF484848),
                                      ),
                                    ),
                                    if (firstState)
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        height: 2,
                                        width: 60,
                                        color: Color(0xFFFF9900),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 25),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    firstState = false;
                                    secondState = true;
                                    thirdState = false;
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '리뷰 목록',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: secondState
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: secondState
                                            ? Color(0xFFFF9900)
                                            : Color(0xFF484848),
                                      ),
                                    ),
                                    if (secondState)
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        height: 2,
                                        width: 60,
                                        color: Color(0xFFFF9900),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 25),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    firstState = false;
                                    secondState = false;
                                    thirdState = true;
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '내 기프티콘',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: thirdState
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: thirdState
                                            ? Color(0xFFFF9900)
                                            : Color(0xFF484848),
                                      ),
                                    ),
                                    if (thirdState)
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        height: 2,
                                        width: 75,
                                        color: Color(0xFFFF9900),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (secondState)
                            reviewDropDown()
                          else if (firstState)
                            saleItemDropDown()
                          else
                            dropDown(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: currentData.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: currentData.length,
                                itemBuilder: (context, index) {
                                  final item = currentData[index];
                                  if (firstState) {
                                    return blockListSale(
                                      item['image']!,
                                      item['brand']!,
                                      item['productName']!,
                                      item['date']!,
                                      item['price']!,
                                      item['category']!,
                                      item['status'] ?? 'sell',
                                    );
                                  } else if (secondState) {
                                    return blockListReview(
                                      item['image']!,
                                      item['brand']!,
                                      item['productName']!,
                                      item['date']!,
                                      item['reviewText']!,
                                      item['rating']!,
                                    );
                                  } else {
                                    return blockList(
                                      item['image']!,
                                      item['brand']!,
                                      item['productName']!,
                                      item['date']!,
                                      item['price']!,
                                      item['category']!,
                                      item['status'] ?? 'normal',
                                      item,
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      firstState
                                          ? Icons.remove_shopping_cart_outlined
                                          : secondState
                                              ? Icons.edit_off_outlined
                                              : Icons.playlist_remove_sharp,
                                      size: 120,
                                      color: Color(0xFFFF9900),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      firstState
                                          ? '판매 중인 상품이 없습니다'
                                          : secondState
                                              ? '작성한 리뷰가 없습니다'
                                              : '기프티콘이 없습니다',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      firstState
                                          ? '아래에서 거래하기를 눌러\n내 기프티콘을 판매해 보세요'
                                          : secondState
                                              ? '기프티콘을 사용한 뒤\n상품에 대해 리뷰를 남겨보세요'
                                              : '아래에서 등록하기를 눌러\n갤러리 속 기프티콘을 등록해주세요',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(currentIndex: 0),
    );
  }

// 판매 바텀시트
  void _showSaleBottomSheet(BuildContext context, String status) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),
              if (status == 'sold' || status == 'settled') ...[
                ListTile(
                  leading: Icon(Icons.image, color: Colors.orange),
                  title: Text('원본 이미지 보기'),
                  onTap: () {
                    // 원본 이미지 보기 기능 구현
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_support, color: Colors.orange),
                  title: Text('문의하기'),
                  onTap: () async {
                    if (await canLaunchUrl(openChatUrl)) {
                      await launchUrl(openChatUrl);
                    } else {
                      throw 'Could not launch $openChatUrl';
                    }
                    Navigator.pop(context);
                  },
                ),
              ] else if (status == 'sell') ...[
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.orange),
                  title: Text('판매 취소하기'),
                  onTap: () {
                    // 판매 취소 기능 구현
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image, color: Colors.orange),
                  title: Text('원본 이미지 보기'),
                  onTap: () {
                    // 원본 이미지 보기 기능 구현
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_support, color: Colors.orange),
                  title: Text('문의하기'),
                  onTap: () async {
                    if (await canLaunchUrl(openChatUrl)) {
                      await launchUrl(openChatUrl);
                    } else {
                      throw 'Could not launch $openChatUrl';
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

// 내 기프티콘 바텀시트
  void _showBottomSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // 배경색을 흰색으로 설정
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '사용 완료된 기프티콘',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.swap_horiz, color: Colors.orange),
                title: Text(
                  '미사용 전환하기',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  // 미사용 전환하기 동작 추가
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review, color: Colors.orange),
                title: Text(
                  '리뷰 작성하기',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  // 리뷰 작성하기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteReview(
                        image: item['image'],
                        brand: item['brand'],
                        productName: item['productName'],
                        date: item['date'],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.orange),
                title: Text(
                  '삭제하기',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  // 삭제하기 동작 추가
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChoicePopupWidget(
                        message: "삭제 시 복구가 불가능합니다\n이 기프티콘을 정말 삭제하시겠습니까?",
                        onConfirm: () {
                          // 여기서 삭제 작업 수행
                          print("기프티콘 삭제됨");
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void toggleSelect(value) {
    setState(() {
      firstState = value == 0;
      secondState = value == 1;
      thirdState = value == 2;
      isSelected = [firstState, secondState, thirdState];
    });
  }

  Widget saleItemDropDown() {
    List<String> dropDownList = ['유효기간순', '높은금액순', '낮은금액순'];

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(Icons.keyboard_arrow_down),
        alignment: Alignment.centerRight,
        value: dropDownValue,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        items: dropDownList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropDownValue = value!;

            DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

            if (dropDownValue == '유효기간순') {
              saleItemData.sort((a, b) {
                DateTime dateA = dateFormat.parse(a['date']);
                DateTime dateB = dateFormat.parse(b['date']);
                return dateA.compareTo(dateB);
              });
            } else if (dropDownValue == '높은금액순') {
              saleItemData.sort((a, b) =>
                  int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), ''))
                      .compareTo(
                    int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), '')),
                  ));
            } else if (dropDownValue == '낮은금액순') {
              saleItemData.sort((a, b) =>
                  int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), ''))
                      .compareTo(
                    int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), '')),
                  ));
            }
          });
        },
      ),
    );
  }

  Widget reviewDropDown() {
    List<String> dropDownList = ['별점순', '날짜순'];

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(Icons.keyboard_arrow_down),
        alignment: Alignment.centerRight,
        value: reviewSortValue,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        items: dropDownList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            reviewSortValue = value!;

            if (reviewSortValue == '날짜순') {
              reviewData.sort((a, b) {
                return b['date'].compareTo(a['date']);
              });
            } else if (reviewSortValue == '별점순') {
              reviewData.sort((a, b) => b['rating'].compareTo(a['rating']));
            }
          });
        },
      ),
    );
  }

  Widget dropDown() {
    List<String> dropDownList = ['유효기간순', '높은금액순', '낮은금액순'];

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(Icons.keyboard_arrow_down),
        alignment: Alignment.centerRight,
        value: dropDownValue,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        items: dropDownList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropDownValue = value!;

            DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

            if (dropDownValue == '유효기간순') {
              myCouponData.sort((a, b) {
                DateTime dateA = dateFormat.parse(a['date']);
                DateTime dateB = dateFormat.parse(b['date']);
                return dateA.compareTo(dateB);
              });
            } else if (dropDownValue == '높은금액순') {
              myCouponData.sort((a, b) =>
                  int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), ''))
                      .compareTo(
                    int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), '')),
                  ));
            } else if (dropDownValue == '낮은금액순') {
              myCouponData.sort((a, b) =>
                  int.parse(a['price'].replaceAll(RegExp(r'[^\d]'), ''))
                      .compareTo(
                    int.parse(b['price'].replaceAll(RegExp(r'[^\d]'), '')),
                  ));
            }
          });
        },
      ),
    );
  }

// 내 기프티콘
  Widget blockList(String image, String brand, String productName, String date,
      String price, String category, String status, Map<String, dynamic> item) {
    Color backgroundColor;
    Color textColor = Colors.black;
    String label = '';

    if (status == 'used') {
      backgroundColor = Color(0xFFFF9F0E);
      textColor = Colors.white;
      label = '사용 완료';
    } else if (status == 'purchased') {
      backgroundColor = Colors.white;
      label = '구매한 쿠폰';
    } else {
      backgroundColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(image),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                          Text(
                            productName,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "유효기간",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "금액",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                price,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "카테고리",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'used'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if (status == 'used') {
                  // 사용된 기프티콘일 때
                  _showBottomSheet(context, item);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CouponDetail(
                        image: image,
                        barcode: '1234567890123', // 실제 바코드 값으로 교체 필요
                        productName: productName,
                        brand: brand,
                        expiryDate: date,
                        price: price,
                        categories: [category],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          if (label.isNotEmpty)
            Positioned(
              top: 12,
              right: 13,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: status == 'used' ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

// 판매 중
  Widget blockListSale(String image, String brand, String productName,
      String date, String price, String category, String status) {
    // 상태에 따라 배경색과 텍스트 설정
    Color backgroundColor = Colors.white;
    String label = '';

    if (status == 'sold') {
      label = '판매 완료';
    } else if (status == 'settled') {
      backgroundColor = Color(0xFFFF9F0E);
      label = '정산 완료';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(image),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: status == 'settled'
                                  ? Colors.white
                                  : Colors.black,
                              letterSpacing: -0.1,
                            ),
                          ),
                          Text(
                            productName,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: status == 'settled'
                                  ? Colors.white
                                  : Colors.black,
                              letterSpacing: -0.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "유효기간",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "금액",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                price,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "카테고리",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: status == 'settled'
                                      ? Colors.white
                                      : Color(0xFF484848),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if (status == 'sold' ||
                    status == 'settled' ||
                    status == 'sell') {
                  _showSaleBottomSheet(context, status);
                }
              },
            ),
          ),
          if (label.isNotEmpty)
            Positioned(
              top: 12,
              right: 13,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: status == 'settled' ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

// 리뷰 목록
  Widget blockListReview(String image, String brand, String productName,
      String date, String reviewText, double rating) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          brand,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) {
                              if (index < rating.floor()) {
                                // 정수
                                return Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFF484848),
                                  size: 18,
                                );
                              } else if (index < rating) {
                                // 소수
                                return Icon(
                                  Icons.star_half_rounded,
                                  color: Color(0xFF484848),
                                  size: 18,
                                );
                              } else {
                                // 빈 경우
                                return Icon(
                                  Icons.star_outline_rounded,
                                  color: Color(0xFF484848),
                                  size: 18,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          reviewText,
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              color: Color(0xFF484848),
                              letterSpacing: -0.25,
                              height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteReview(
                  image: image,
                  brand: brand,
                  productName: productName,
                  date: date,
                  initialRating: rating,
                  initialReviewText: reviewText,
                  isEditMode: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
