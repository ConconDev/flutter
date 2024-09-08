import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final ImageProvider? backgroundImage;

  const TransactionHistoryScreen({Key? key, required this.backgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (backgroundImage == null) {
      // null 체크 추가
      return Scaffold(
        body: Center(
          child: Text('No background image available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '거래 내역 확인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                    child:
                        Text('Failed to load image: $error'));
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildTransactionItem(
                      'assets/imgs/cafe_sample1.png',
                      '이디야커피',
                      '카페라테 (ICE)',
                      '00000013',
                      '2024년 1월 13일',
                      '5,500원',
                    ),
                    _buildTransactionItem(
                      'assets/imgs/cafe_sample2.png',
                      '스타벅스',
                      '카페 아메리카노 Tall',
                      '00000017',
                      '2024년 1월 22일',
                      '3,800원',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String image, String brand, String productName,
      String transactionId, String transactionDate, String price) {
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
                            '거래 번호',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            transactionId,
                            style: TextStyle(
                              fontFamily: "Inter",
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
                            '거래일',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            transactionDate,
                            style: TextStyle(
                              fontFamily: "Inter",
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
                            '금액',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: "Inter",
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
            // 거래 내역 아이템 터치 시 동작 정의
          },
        ),
      ),
    );
  }
}
