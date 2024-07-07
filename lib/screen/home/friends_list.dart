import 'package:flutter/material.dart';
import 'dart:math';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  // 좋아요 상태 초기화
  List<bool> heartStates = List.generate(10, (_) => Random().nextBool());
  List<String> nameList = [
    'Mia',
    'Sujin',
    'Numbereal',
    'its_soyunn',
    'seeya00_',
    'osjKate',
    'kingwangjjang',
    'Hello',
    'NameSample',
    'GoodName'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 바 제거
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            '친구 목록',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Colors.transparent, // appBar 투명색
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(clipBehavior: Clip.none, children: [
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
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 70),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                // 여기에 Main body
                itemCount: 10,
                itemBuilder: (context, index) {
                  return blockList(
                      'assets/user/user_image_sample ${index + 1}.png',
                      nameList[index],
                      index);
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget blockList(String image, String name, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 70),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    heartStates[index] = !heartStates[index];
                    print("변경 후: ${heartStates[index]}");
                    print(heartStates);
                  });
                },
                child: heartStates[index]
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.red,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.favorite_border,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
