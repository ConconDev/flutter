import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user_profile_review.dart'; // Import the new UserProfileReview file

class UserProfileScreen extends StatefulWidget {
  final ImageProvider backgroundImage;
  final int initialTab; // 초기 탭을 지정하는 매개변수 추가 (0: 판매 상품, 1: 리뷰 목록)

  const UserProfileScreen({
    Key? key,
    required this.backgroundImage,
    this.initialTab = 0, // 기본값으로 0 (판매 상품 탭)
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String saleSortValue = "높은 가격순"; // 판매 상품의 정렬 옵션
  String reviewSortValue = "최신순"; // 리뷰 목록의 정렬 옵션
  late bool isSaleTab; // true: 판매 상품, false: 리뷰 목록

  final List<Map<String, dynamic>> saleItems = [
    // 판매 상품 데이터
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '카페 아메리카노 Tall',
      'originalPrice': '4500원',
      'price': '3000원',
      'discount': '33% 할인',
      'date': '2024.03.30까지',
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '카페 아메리카노 Tall',
      'originalPrice': '4500원',
      'price': '3800원',
      'discount': '16% 할인',
      'date': '2024.05.30까지',
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    // 리뷰 데이터
    {
      'image': 'assets/imgs/cafe_sample1.png',
      'brand': '스타벅스',
      'productName': '따뜻한 카페라테 커플세트',
      'reviewText':
          '커플세트인데 혼자 두잔 다마셨어요 솔직히 다들 갑자기 라테 땡길때 있잖아요 근데 다른분들은 그냥 비싼걸로 시켜드세요 넘 배부른거',
      'rating': 4.0,
      'date': '2024-03-30',
    },
    {
      'image': 'assets/imgs/cafe_sample2.png',
      'brand': '스타벅스',
      'productName': '행복한 기운 ICE',
      'reviewText':
          '저 케이크가 진짜 맛도리입니다 위에 올라간게 약간 느끼할줄알았는데 생각보다 괜찮았어요 근데 가격대비 별로인듯한? 그런 느낌이에요',
      'rating': 3.0,
      'date': '2024-04-01',
    },
  ];

  @override
  void initState() {
    super.initState();
    isSaleTab = widget.initialTab == 0; // 초기 탭을 설정 (0: 판매 상품, 1: 리뷰 목록)
    _initializeSort(); // 초기 정렬을 설정
  }

  // 초기 정렬 설정 함수
  void _initializeSort() {
    if (isSaleTab) {
      _sortSaleItems(); // 판매 상품 초기 정렬
    } else {
      _sortReviewItems(); // 리뷰 목록 초기 정렬
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '프로필 상세',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          Column(
            children: [
              const SizedBox(height: 110),
              _buildProfileHeader(),
              _buildTabBarWithDropdown(),
              Expanded(child: _buildContent()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                AssetImage('assets/user/user_image_sample.png'), // 프로필 이미지
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mia',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '#0000023',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarWithDropdown() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 2, 20, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildTab('판매 상품', isSaleTab, () {
                setState(() {
                  isSaleTab = true;
                  _sortSaleItems(); // 판매 상품으로 탭 변경 시 정렬
                });
              }),
              SizedBox(width: 25),
              _buildTab('리뷰 목록', !isSaleTab, () {
                setState(() {
                  isSaleTab = false;
                  _sortReviewItems(); // 리뷰 목록으로 탭 변경 시 정렬
                });
              }),
            ],
          ),
          isSaleTab ? _buildSaleDropdown() : _buildReviewDropdown(), // 각 상태에 따라 다른 드롭다운 표시
        ],
      ),
    );
  }

  Widget _buildSaleDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.black87.withOpacity(0.8),
        style: TextStyle(
            color: Colors.white, fontFamily: 'Inter', fontSize: 15),
        icon: Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.white,
        ),
        value: saleSortValue,
        items: ['높은 가격순', '낮은 가격순', '만료일자순']
            .map((value) =>
                DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: (value) {
          setState(() {
            saleSortValue = value!;
            _sortSaleItems();
          });
        },
      ),
    );
  }

  Widget _buildReviewDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.black87.withOpacity(0.8),
        style: TextStyle(
            color: Colors.white, fontFamily: 'Inter', fontSize: 15),
        icon: Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.white,
        ),
        value: reviewSortValue,
        items: ['최신순', '별점순']
            .map((value) =>
                DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: (value) {
          setState(() {
            reviewSortValue = value!;
            _sortReviewItems();
          });
        },
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFFFF9900) : Colors.white,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 2),
              height: 2,
              width: 60,
              color: Color(0xFFFF9900),
            ),
        ],
      ),
    );
  }

  void _sortSaleItems() {
    if (saleSortValue == '높은 가격순') {
      saleItems.sort((a, b) => int.parse(b['price'].replaceAll(RegExp(r'[^0-9]'), ''))
          .compareTo(int.parse(a['price'].replaceAll(RegExp(r'[^0-9]'), ''))));
    } else if (saleSortValue == '낮은 가격순') {
      saleItems.sort((a, b) => int.parse(a['price'].replaceAll(RegExp(r'[^0-9]'), ''))
          .compareTo(int.parse(b['price'].replaceAll(RegExp(r'[^0-9]'), ''))));
    } else if (saleSortValue == '만료일자순') {
      saleItems.sort((a, b) {
        DateTime dateA = DateFormat('yyyy.MM.dd까지').parse(a['date']);
        DateTime dateB = DateFormat('yyyy.MM.dd까지').parse(b['date']);
        return dateA.compareTo(dateB);
      });
    }
  }

  void _sortReviewItems() {
    if (reviewSortValue == '최신순') {
      reviews.sort((a, b) => b['date'].compareTo(a['date']));
    } else if (reviewSortValue == '별점순') {
      reviews.sort((a, b) => b['rating'].compareTo(a['rating']));
    }
  }

  Widget _buildContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: isSaleTab ? saleItems.length : reviews.length,
      itemBuilder: (context, index) {
        final item = isSaleTab ? saleItems[index] : reviews[index];
        return isSaleTab ? _buildSaleItem(item) : _buildReviewItem(item);
      },
    );
  }

  Widget _buildSaleItem(Map<String, dynamic> item) {
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
                    child: Image.asset(item['image']),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['brand'],
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: -0.1,
                        ),
                      ),
                      Text(
                        item['productName'],
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: -0.1,
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        width: 40,
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        '정가 ${item['originalPrice']} → ${item['price']} (${item['discount']})\n${item['date']}',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Color(0xFF484848),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> item) {
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
          onTap: () {
            // Navigate to UserProfileReview with the relevant data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileReview(
                  image: item['image'],
                  brand: item['brand'],
                  productName: item['productName'],
                  date: item['date'],
                  rating: item['rating'],
                  reviewText: item['reviewText'],
                  backgroundImage: widget.backgroundImage, // Pass the background image
                ),
              ),
            );
          },
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(item['image']),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          item['brand'],
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          item['productName'],
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(
                              index < item['rating']
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: Color(0xFF484848),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          item['reviewText'],
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color(0xFF484848),
                            letterSpacing: -0.25,
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
