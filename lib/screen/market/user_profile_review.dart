import 'dart:ui';
import 'package:flutter/material.dart';

class UserProfileReview extends StatelessWidget {
  final String image; // 상품 이미지
  final String brand; // 브랜드명
  final String productName; // 상품명
  final String date; // 사용 완료 날짜
  final double rating; // 별점
  final String reviewText; // 리뷰 텍스트
  final ImageProvider backgroundImage; // 배경 이미지

  const UserProfileReview({
    Key? key,
    required this.image,
    required this.brand,
    required this.productName,
    required this.date,
    required this.rating,
    required this.reviewText,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '$brand $productName', // 제목에 브랜드와 상품명 표시
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: backgroundImage, // 배경 이미지
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight * 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 배경을 투명으로 설정
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(image), // 상품 이미지
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 27),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9, // 사진과 동일한 너비
                        padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                brand, // 브랜드명
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                productName, // 상품명
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '$date 사용 완료', // 사용 완료 날짜
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildRatingStars(rating), // 별점 표시
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                reviewText, // 리뷰 텍스트
                                textAlign: TextAlign.justify, // 양쪽 정렬
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 별점 표시 위젯
  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(right: 4),
          child: Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            color: Color(0xff484848),
            size: 30,
          ),
        ),
      ),
    );
  }
}
