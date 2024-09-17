import 'package:flutter/material.dart';
import 'product.dart'; // ProductDetailScreen import

class SearchScreen extends StatefulWidget {
  final ImageProvider backgroundImage; // 배경 이미지

  const SearchScreen({super.key, required this.backgroundImage});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> displayedResults = [];
  List<Map<String, dynamic>> allResults = []; // 전체 검색 결과
  int itemsPerPage = 3; // 한 번에 보여줄 아이템 수
  int currentPage = 0; // 현재 페이지 번호

  @override
  void initState() {
    super.initState();
  }

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
        title: _buildSearchBar(context), // 검색 바
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
              image: widget.backgroundImage, // 배경 이미지
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: kToolbarHeight * 2.1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    '전체 ${allResults.length}건',
                    style: TextStyle(
                      color: allResults.isNotEmpty
                          ? Colors.black87
                          : Colors.grey[300],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: displayedResults.length + 1,
                    itemBuilder: (context, index) {
                      if (index < displayedResults.length) {
                        final item = displayedResults[index];
                        return _buildSearchResultItem(item); // 검색 결과 아이템 빌드
                      } else if (displayedResults.length < allResults.length) {
                        return _buildLoadMoreButton(); // 더 보기 버튼
                      } else {
                        return SizedBox.shrink(); // 빈 공간 반환
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 검색 바 UI
  Widget _buildSearchBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: '검색어를 입력하세요',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.grey),
                onPressed: () {
                  _search(searchController.text);
                },
              ),
            ),
            onSubmitted: (query) {
              _search(query);
            },
          ),
        ),
      ],
    );
  }

  // 검색 로직 처리 함수
  void _search(String query) {
    FocusScope.of(context).unfocus(); // 키보드 닫기
    if (query == '스타벅스') {
      _showSampleResults(); // 스타벅스 검색 시 샘플 데이터 표시
    } else {
      setState(() {
        displayedResults = []; // 검색 결과가 없을 때 빈 리스트로 설정
        allResults = [];
      });
    }
  }

  // 샘플 검색 결과 표시 함수
  void _showSampleResults() {
    // 예시 데이터
    final sampleResults = [
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
        'productName': '무료 음료 쿠폰 (벤티 사이즈)',
        'originalPrice': '7300원',
        'price': '6200원',
        'discount': '15% 할인',
        'date': '2024.03.30까지',
      },
      {
        'image': 'assets/imgs/cafe_sample3.png',
        'brand': '스타벅스',
        'productName': '자몽 허니 블랙티 Tall',
        'originalPrice': '5700원',
        'price': '5400원',
        'discount': '5% 할인',
        'date': '2024.03.30까지',
      },
      {
        'image': 'assets/imgs/cafe_sample4.png',
        'brand': '스타벅스',
        'productName': '돌체라떼 Tall',
        'originalPrice': '5800원',
        'price': '5600원',
        'discount': '3% 할인',
        'date': '2024.03.30까지',
      },
    ];

    setState(() {
      allResults = sampleResults;
      displayedResults = allResults.take(itemsPerPage).toList(); // 처음엔 3개만 표시
      currentPage = 1;
    });
  }

  // 더 보기 버튼 빌드
  Widget _buildLoadMoreButton() {
    return Center(
      child: TextButton(
        onPressed: _loadMoreResults,
        child: Text(
          '검색 결과 더보기 ↓',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // 추가 검색 결과 로드 함수
  void _loadMoreResults() {
    setState(() {
      currentPage++;
      displayedResults = allResults.take(currentPage * itemsPerPage).toList();
    });
  }

  // 검색 결과 아이템 UI 빌드
  Widget _buildSearchResultItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // 아이템 터치 시 화면 전환
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: item, // 선택된 제품 정보 전달
              backgroundImage: widget.backgroundImage, // 배경 이미지 전달
            ),
          ),
        );
      },
      child: Padding(
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
                      child: Image.asset(item['image']), // 이미지 표시
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
      ),
    );
  }
}
