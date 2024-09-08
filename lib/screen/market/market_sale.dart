import 'package:flutter/material.dart';
import 'dart:io'; // File 클래스 사용을 위해 추가
import 'package:intl/intl.dart';

import 'market_sale_detail.dart'; // 날짜 포맷을 위한 패키지 추가

class MarketSaleScreen extends StatefulWidget {
  final ImageProvider? backgroundImage; // nullable 처리

  const MarketSaleScreen({Key? key, required this.backgroundImage}) : super(key: key);

  @override
  _MarketSaleScreenState createState() => _MarketSaleScreenState();
}

class _MarketSaleScreenState extends State<MarketSaleScreen> {
  String dropDownValue = '유효기간순'; // 기본값 설정
  List<Map<String, dynamic>> myCouponData = [
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'date': '2024년 4월 8일',
      'price': '14,000원',
      'category': '카페 음료',
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'date': '2024년 12월 21일',
      'price': '21,000원',
      'category': '카페 음료',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 초기화 로직 추가
    if (widget.backgroundImage == null) {
      print('Error: Background image is null in MarketSaleScreen');
    }
  }

  void _sortCouponData() {
    DateFormat dateFormat = DateFormat('yyyy년 M월 d일');
    setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.backgroundImage == null) { // null 체크 추가
      return Scaffold(
        body: Center(
          child: Text('No background image available'), // 이미지가 없을 때 표시할 텍스트
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '기프티콘 판매',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // 배경 이미지 설정
          Positioned.fill(
            child: Image(
              image: widget.backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Failed to load image: $error')); // 이미지 로드 실패 처리
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 110),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '판매 가능한 기프티콘 목록',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    DropdownButtonHideUnderline( // 밑줄 제거
                      child: DropdownButton<String>(
                        value: dropDownValue,
                        dropdownColor: Colors.black.withOpacity(0.8),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        items: ['유효기간순', '높은금액순', '낮은금액순']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value!;
                            _sortCouponData(); // 선택 변경 시 정렬 수행
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myCouponData.length,
                  itemBuilder: (context, index) {
                    final item = myCouponData[index];
                    return _buildCouponItem(
                      item['image'],
                      item['brand'],
                      item['productName'],
                      item['date'],
                      item['price'],
                      item['category'],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponItem(String image, String brand, String productName, String expiryDate, String price, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          contentPadding: const EdgeInsets.all(5),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image, fit: BoxFit.cover),
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
                          color: Colors.black,
                          letterSpacing: -0.1,
                        ),
                      ),
                      Text(
                        productName,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
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
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            expiryDate,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
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
                            "금액",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
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
                            "카테고리",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          onTap: () {
  // 쿠폰 아이템 터치 시 동작 정의
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MarketSaleDetailScreen(
        backgroundImage: widget.backgroundImage!, // 캡처된 배경 이미지 전달
        image: image, // 쿠폰 이미지 전달
        brand: brand, // 브랜드 이름 전달
        productName: productName, // 상품 이름 전달
        expiryDate: expiryDate, // 유효기간 전달
        price: price, // 가격 전달
      ),
    ),
  );
},
        ),
      ),
    );
  }
}
