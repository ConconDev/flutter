import 'package:flutter/material.dart';
import 'dart:ui';

import 'review_list.dart';

class ProductDetailScreen extends StatefulWidget {
  final ImageProvider backgroundImage; // 배경 이미지
  final Map<String, dynamic> product; // 제품 정보

  const ProductDetailScreen({
    super.key,
    required this.backgroundImage,
    required this.product,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.product['brand']} ${widget.product['productName']}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.9)),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(height: 30),
                  _buildProductImageSection(),
                  _buildProductInfoSection(),
                  _buildTabBarSection(),
                  _buildTabContent(),
                  SizedBox(height: 10), // 구매하기 버튼의 공간 확보를 위한 여백
                ],
              ),
            ),
          ),
          // 블러 배경
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // 구매하기 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPurchaseButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImageSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(widget.product['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 20),
            SizedBox(width: 4),
            Text('4.5 (800)', style: TextStyle(fontSize: 14)),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: TextButton(
  style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.grey[300])),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewListScreen(
          productName: widget.product['productName'], // 제품 이름 전달
          brandName: widget.product['brand'], // 브랜드 이름 전달
          backgroundImage: widget.backgroundImage, // 배경 이미지 전달
          productImage: widget.product['image'], // 제품 이미지 경로 전달
          averageRating: 4.5, // 예시 평균 별점 전달 (수정 가능)
          originalPrice: widget.product['originalPrice'], // 원래 가격 전달
          discountedPrice: widget.product['price'], // 할인된 가격 전달
        ),
      ),
    );
  },
  child: Text(
    '후기 확인하기 →',
    style: TextStyle(fontSize: 14, color: Colors.black),
  ),
),


            ),
          ],
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '정가 ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff484848),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    '${widget.product['originalPrice']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      color: Color(0xff484848),
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    ' → ${widget.product['price']}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Text('2024.03.30까지', style: TextStyle(fontSize: 14)),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarSection() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      tabs: [
        Tab(text: '사용 안내'),
        Tab(text: '유의사항'),
        Tab(text: '추천 상품'),
        Tab(text: '비교하기'),
      ],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildCommonTabContent(_buildUsageInfoTab()),
          _buildCommonTabContent(_buildPrecautionTab()),
          _buildCommonTabContent(_buildRecommendedProductsTab()),
          _buildCommonTabContent(_buildComparisonTab()),
        ],
      ),
    );
  }

  Widget _buildCommonTabContent(Widget content) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildUsageInfoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('일반 상품 주의 사항'),
        _buildBulletText(
            '현금 영수증 발급 및 프리퀀시 적립은 가능하나, 브랜드 운영 정책에 따라 다르게 적용될 수 있습니다.'),
        _buildBulletText(
            '[e-Gift item] 상품은 앱 내 사용(사이렌오더 포함 온라인 구매)이 불가하며 매장 내 제시하는 방법으로 사용하셔야 합니다.'),
        SizedBox(height: 16),
        _buildSectionHeader('무료 음료 및 원두 쿠폰 주의 사항'),
        _buildBulletText('무료 음료 및 원두 쿠폰은 금액권이 아니며, 제품 교환형 상품입니다.'),
        _buildBulletText(
            '무료 음료 및 원두 쿠폰의 정가는 교환 가능한 최고가 상품의 정가에 맞추어져 있으며 선택한 교환 상품 외 다른 상품에 잔액 적용되지 않습니다.'),
        _buildBulletText(
            '무료 음료 쿠폰으로는 병 음료, 생수, 요거트, POC 브루드 커피, 바나나 음료, 블렌디드 음료 등은 교환하실 수 없습니다.'),
        _buildBulletText('무료 음료 쿠폰은 현금 영수증 발급 및 프리퀀시 적립이 불가합니다.'),
        _buildBulletText(
            '[리저브] 표시가 있는 상품만 리저브 상품 교환이 가능하며 그 외에는 리저브 상품을 교환하실 수 없습니다.'),
        SizedBox(height: 16),
        _buildSectionHeader('사용 불가 매장'),
        _buildBulletText('미군 내 입점 점포 및 특수 매장 (공항, 역, 백화점, 군 부대 등)'),
      ],
    );
  }

  Widget _buildPrecautionTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBulletText(
            '위 상품은 개인간의 거래를 통한 상품으로 구매 후 기간 연장 및 환불 불가하니 꼭 유효기간 내 사용해주십시오.'),
        _buildBulletText(
            '공항, 백화점 및 고속도로 휴게소, 면세점, 대학교 등 특수 매장에서는 사용이 제한될 수 있습니다.'),
        _buildBulletText('교환형 상품 경우 교환처(매장)에서 상품 가격을 인상했다면 추가 금액이 발생될 수 있습니다.'),
        _buildBulletText('교환형 상품 경우 교환처(매장)에서 타 상품 교환 불가합니다.'),
        _buildBulletText(
            '금액권 상품 경우 잔여 금액은 해당 상품 교환처(매장) 방문 후 직원을 통해 확인 가능합니다.'),
        _buildBulletText(
            '프로모션 및 이벤트 상품 등으로 구매 상품의 결제금액과 매장 내 영수증 금액과 상이할 수 있습니다.'),
        _buildBulletText('제휴 할인 중복 적용, 자체 적립 등 브랜드별 정책에 따라 적용되지 않을 수 있습니다.'),
        _buildBulletText('동일 고객이 상품 구매 후 앱 내 판매 기능을 통한 재판매는 지원되지 않습니다.'),
        _buildBulletText('금액권으로 명시 되지 않은 교환형 상품은 해당 상품과의 교환만 책임지고 있습니다.'),
      ],
    );
  }

  Widget _buildRecommendedProductsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('해당 브랜드의 다른 제품'),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecommendedProductItem('스타벅스 무료 음료 쿠폰',
                  'assets/imgs/cafe_sample2.png', '7300원', '6200원', '15% 할인'),
              _buildRecommendedProductItem('스타벅스 자몽 허니 블랙티 Tall',
                  'assets/imgs/cafe_sample3.png', '5700원', '5400원', '5% 할인'),
              _buildRecommendedProductItem('스타벅스 돌체라떼 Tall',
                  'assets/imgs/cafe_sample4.png', '5800원', '5600원', '3% 할인'),
            ],
          ),
        ),
        SizedBox(height: 20),
        _buildSectionHeader('함께 구매하기 좋은 제품'),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecommendedProductItem('이디야 아메리카노 (L)',
                  'assets/imgs/cafe_sample1.png', '3200원', '2900원', '10% 할인'),
              _buildRecommendedProductItem('투썸플레이스 카페라떼(R)',
                  'assets/imgs/cafe_sample2.png', '6000원', '4650원', '22% 할인'),
              _buildRecommendedProductItem('빽다방 아메리카노',
                  'assets/imgs/cafe_sample3.png', '1500원', '1300원', '15% 할인'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProductItem(String title, String imagePath,
      String originalPrice, String discountedPrice, String discount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath,
                height: 100, width: 100, fit: BoxFit.cover),
          ),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('정가 $originalPrice → 최저가 $discountedPrice',
              style: TextStyle(fontSize: 12)),
          Text(discount, style: TextStyle(fontSize: 12, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildComparisonTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('유효기간',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('할인율',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('가격',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(width: 30),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _buildComparisonList(),
        SizedBox(
          height: 20,
        ),
        Center(
            child: Text(
          '우측 화살표를 눌러 상품 페이지로 이동할 수 있습니다',
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.grey[500],
              letterSpacing: 0.6),
        )),
      ],
    );
  }

  Widget _buildComparisonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComparisonItem('2024.03.18', '33% 할인', '3000원'),
        _buildComparisonItem('2024.03.23', '33% 할인', '3000원'),
        _buildComparisonItem('2024.04.01', '30% 할인', '3150원'),
        _buildComparisonItem('2024.04.21', '30% 할인', '3150원'),
        _buildComparisonItem('2024.04.28', '28% 할인', '3240원'),
        _buildComparisonItem('2024.05.10', '33% 할인', '3000원'),
      ],
    );
  }

  Widget _buildComparisonItem(String date, String discountRate, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(fontSize: 14)),
          Text(discountRate, style: TextStyle(fontSize: 14)),
          Text(price, style: TextStyle(fontSize: 14)),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              size: 15,
            ),
            onPressed: () {}, // 상품 판매 페이지로 이동하는 기능 추가
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            '구매하기',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
