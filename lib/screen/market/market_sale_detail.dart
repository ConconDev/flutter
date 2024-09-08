import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';

import '../popup_widget.dart'; // Number formatting

class MarketSaleDetailScreen extends StatefulWidget {
  final ImageProvider backgroundImage;
  final String image;
  final String brand;
  final String productName;
  final String expiryDate;
  final String price;

  const MarketSaleDetailScreen({
    Key? key,
    required this.backgroundImage,
    required this.image,
    required this.brand,
    required this.productName,
    required this.expiryDate,
    required this.price,
  }) : super(key: key);

  @override
  _MarketSaleDetailScreenState createState() => _MarketSaleDetailScreenState();
}

class _MarketSaleDetailScreenState extends State<MarketSaleDetailScreen> {
  final TextEditingController _priceController = TextEditingController();
  String discountText = '(100% 할인)';

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_updateDiscountText);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _updateDiscountText() {
    if (_priceController.text.isEmpty) {
      setState(() {
        discountText = '(100% 할인)';
      });
      return;
    }

    int originalPrice =
        int.parse(widget.price.replaceAll(RegExp(r'[^\d]'), ''));
    int enteredPrice = int.tryParse(_priceController.text) ?? 0;

    // 가격이 정가보다 비싼 경우 0으로 고정
    if (enteredPrice > originalPrice) {
      _priceController.text = '';
      enteredPrice = 0;
    }

    double discount = (1 - (enteredPrice / originalPrice)) * 100;

    setState(() {
      discountText = '(${discount.toStringAsFixed(0)}% 할인)';
    });
  }

  @override
  Widget build(BuildContext context) {
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
              image: widget.backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Failed to load image: $error'));
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                // 상품 이미지
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      child: Image.asset(
                        widget.image,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width - 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 상품 정보
                _buildInfoContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.brand,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '정가 ${widget.price}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF484848),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '${widget.expiryDate}까지',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF484848),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                // 가격 설정
                _buildInfoContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '가격 설정',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 50,
                            ),
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 13),
                              ),
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('원', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 10),
                          Text(
                            discountText,
                            style: TextStyle(
                              color: Color(0xFF484848),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 유의사항
                _buildInfoContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '유의사항',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '판매하기를 터치하시면 즉시 판매 리스트에 등록되며, 등록하신 가격의 10%가 수수료로 부과됩니다. 가격 수정은 불가하며 판매 취소 후 재등록하셔야 합니다. 사용된 기프티콘일 경우 반드시 판매가 취소되어야 하며, 취소 처리하지 않을 경우 정산금은 회수되고 이후 계정 사용에 지장이 있을 수 있습니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF484848),
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // 판매하기 버튼
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ChoicePopupWidget(
                            message: '가격 변경이 불가능합니다\n이 가격으로 판매하시겠습니까?',
                            onConfirm: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '판매하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
