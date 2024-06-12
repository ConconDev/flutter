import 'package:flutter/material.dart';

class PageSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 428,
          height: 926,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: -446,
                top: -22,
                child: Container(
                  width: 1213,
                  height: 948,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/1213x948"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 428,
                  height: 926,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.699999988079071),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 38,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/23x23"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 302,
                top: 337,
                child: Text(
                  '터치해 수정하세요',
                  style: TextStyle(
                    color: Color(0xFFF9F9F9),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 173,
                top: 41,
                child: Text(
                  '내 정보 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 102,
                top: 95,
                child: Container(
                  width: 225,
                  height: 225,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 225,
                          height: 225,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://via.placeholder.com/225x225"),
                              fit: BoxFit.fill,
                            ),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 165,
                        top: 165,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFDFDFD),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 277,
                top: 270,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/25x25"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41,
                top: 355,
                child: Container(
                  width: 346,
                  height: 527,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 316,
                top: 774,
                child: Container(
                  width: 40,
                  height: 16,
                  decoration: ShapeDecoration(
                    color: Color(0xFF4583E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.50),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 342,
                top: 776,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 743,
                child: Text(
                  '판매 목록',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 773,
                child: Text(
                  '후기 목록',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 425,
                child: Text(
                  '아바타 색상 설정',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 705,
                child: Text(
                  '커뮤니티 공개 설정',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 189,
                top: 429,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 9,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 382,
                child: Text(
                  '닉네임',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 138,
                top: 382,
                child: Text(
                  'Mia',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 126,
                top: 386,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 9,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 205,
                top: 427,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: ShapeDecoration(
                    color: Color(0xFF949494),
                    shape: OvalBorder(
                      side: BorderSide(width: 0.50, color: Color(0xFF9D9D9D)),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 103,
                top: 463,
                child: Container(
                  width: 222,
                  height: 222,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/222x222"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 316,
                top: 744,
                child: Container(
                  width: 40,
                  height: 16,
                  decoration: ShapeDecoration(
                    color: Color(0xFFA5A5A5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.50),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 318,
                top: 746,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 64,
                top: 817,
                child: Container(
                  width: 300,
                  height: 46,
                  decoration: ShapeDecoration(
                    color: Color(0xFF949494),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 186,
                top: 831,
                child: Text(
                  '저장하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}