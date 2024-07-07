import 'package:concon/screen/home/friends_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCouponList extends StatefulWidget {
  const MyCouponList({super.key});

  @override
  State<MyCouponList> createState() => _MyCouponListState();
}

class _MyCouponListState extends State<MyCouponList> {
  String dropDownValue = "최신순";

  String result = '';
  bool firstState = true;
  bool secondState = false;
  bool thirdState = false;
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [firstState, secondState, thirdState];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //AppBar
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '기프티콘 목록',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        // Body
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/cafe_background.png',
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 202,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 70),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 132,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                  child: Row(
                    children: [
                      // 프로필 이미지
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75.0),
                          child:
                              Image.asset('assets/user/user_image_sample.png'),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // 유저명 및 우측 아이콘
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Mia",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Container()),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CupertinoButton(
                                      minSize: double.minPositive,
                                      onPressed: () {
                                        // 아이콘1 터치 시 화면 전환 구현
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        size: 20,
                                        Icons.contacts,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    CupertinoButton(
                                      minSize: double.minPositive,
                                      onPressed: () {
                                        // 아이콘 2 터치 시 화면 전환 구현
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                FriendsList(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        size: 20,
                                        Icons.person_search,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    CupertinoButton(
                                      minSize: double.minPositive,
                                      onPressed: () {
                                        // 아이콘3 터치 시 화면 전환 구현
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        size: 20,
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              // 가입일(나중에 변수로 수정)
                              children: [
                                SizedBox(
                                  width: 14,
                                ),
                                Text(
                                  "가입일 2024.01.04",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              // 리뷰 및 판매중(나중에 변수로 수정)
                              children: [
                                SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  "리뷰 25  판매중 13",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromRGBO(72, 72, 72, 100),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ToggleButtons(
                      renderBorder: false,
                      color: Color.fromRGBO(72, 72, 72, 100),
                      selectedColor: Colors.black,
                      fillColor: Color.fromARGB(0, 0, 0, 0),
                      isSelected: isSelected,
                      onPressed: toggleSelect,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            '판매 상품',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            '리뷰 목록',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            '내 기프티콘',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      dropDown(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ]),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      blockList('assets/imgs/cafe_sample1.png', '스타벅스',
                          '따뜻한 카페라테 커플세트 ', '2024년 5월 7일', '14,000원', '카페 음료'),
                      blockList('assets/imgs/cafe_sample2.png', '스타벅스',
                          '행복한 기운 ICE', '2024년 12월 21일', '21,000원', '카페 음료'),
                      blockList('assets/imgs/cafe_sample3.png', '이디야커피',
                          '카페라테(ICE)', '2024년 7월 11일', '5,500원', '카페 음료'),
                      blockList('assets/imgs/cafe_sample4.png', '스타벅스',
                          '아이스 카페 아메리카노', '2024년 5월 7일', '4,500원', '카페 음료'),
                    ],
                  ),
                )
              ],
            ), //전체 body Column
          ],
        ),
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      firstState = true;
      secondState = false;
      thirdState = false;
    } else if (value == 1) {
      firstState = false;
      secondState = true;
      thirdState = false;
    } else {
      firstState = false;
      secondState = false;
      thirdState = true;
    }
    setState(
      () {
        isSelected = [firstState, secondState, thirdState];
      },
    );
  }

  Widget dropDown() {
    // 드롭다운 리스트
    List<String> dropDownList = ['최신순', '금액 높은 순', '금액 낮은 순', '유효기간순'];

    if (dropDownValue == "") {
      dropDownValue = dropDownList.first;
    }

    return DropdownButton(
      icon: Icon(Icons.keyboard_arrow_down),
      alignment: Alignment.centerRight,
      value: dropDownValue,
      items: dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropDownValue = value!;
          print(dropDownValue);
        });
      },
    );
  }

  Widget blockList(String image, String brand, String productName, String date,
      String price, String category) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 70),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 215,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          brand,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        productName,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "유효기간",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "금액",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "카테고리",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromRGBO(30, 30, 30, 100),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
