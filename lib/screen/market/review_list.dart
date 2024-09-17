import 'package:flutter/material.dart';

class ReviewListScreen extends StatefulWidget {
  final String productName; // 제품 이름
  final String brandName; // 브랜드 이름
  final ImageProvider backgroundImage; // 배경 이미지
  final String productImage; // 제품 이미지 경로
  final double averageRating; // 평균 별점
  final String originalPrice; // 원래 가격
  final String discountedPrice; // 할인된 가격

  ReviewListScreen({
    Key? key,
    required this.productName,
    required this.brandName,
    required this.backgroundImage,
    required this.productImage,
    required this.averageRating,
    required this.originalPrice,
    required this.discountedPrice,
  }) : super(key: key);

  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final List<Map<String, dynamic>> reviews = [
    {
      'userImage': 'assets/imgs/sample1.jpg',
      'userName': 'Mia',
      'rating': 3.5,
      'date': '2024.01.15 작성',
      'comment':
          '커플세트인데 혼자 두잔 다마셨어요 솔직히 다들 갑자기 라테 땡길때 있잖아요 근데 다른분들은 그냥 비싼걸로 시켜드세요 넘 배부른 거 같습니다',
    },
    {
      'userImage': 'assets/imgs/sample2.jpg',
      'userName': 'Sujin',
      'rating': 4.0,
      'date': '2024.01.10 작성',
      'comment':
          '스벅 카페라떼 제가 좋아합니다 우유비린내 많이 안나고 생각보다 샷이 많이 들어가있어서 카페인 충전에 딱 좋은 느낌! 두 잔 세트라 친구랑 같이 먹기에도 너무 좋아요',
    },
    {
      'userImage': 'assets/imgs/sample3.jpg',
      'userName': 'its_soyunn',
      'rating': 2.5,
      'date': '2024.02.05 작성',
      'comment':
          '생각보다 되게 잘마셨어요 점심 대용으로 먹기에 딱 좋았습니다 핫으로 시키면 얼음이 없어서 오래 마시기 좋아요 단 걸 별로 안 좋아하는데도 괜찮았네요',
    },
    {
      'userImage': 'assets/imgs/sample4.jpg',
      'userName': 'UU',
      'rating': 3.5,
      'date': '2024.01.15 작성',
      'comment': '원두 자체가 그냥 그렇다고 생각했는데 또 어느날 먹어보니 괜찮고 그러네요 기본적으로 얼음이 조금 더 많이 있었으면 완벽했을 것 같아요.',
    },{
      'userImage': 'assets/imgs/sample1.jpg',
      'userName': 'Mia',
      'rating': 3.5,
      'date': '2024.01.15 작성',
      'comment':
          '커플세트인데 혼자 두잔 다마셨어요 솔직히 다들 갑자기 라테 땡길때 있잖아요 근데 다른분들은 그냥 비싼걸로 시켜드세요 넘 배부른 거 같습니다',
    },
    {
      'userImage': 'assets/imgs/sample2.jpg',
      'userName': 'Sujin',
      'rating': 4.0,
      'date': '2024.01.10 작성',
      'comment':
          '스벅 카페라떼 제가 좋아합니다 우유비린내 많이 안나고 생각보다 샷이 많이 들어가있어서 카페인 충전에 딱 좋은 느낌! 두 잔 세트라 친구랑 같이 먹기에도 너무 좋아요',
    },
    {
      'userImage': 'assets/imgs/sample3.jpg',
      'userName': 'its_soyunn',
      'rating': 2.5,
      'date': '2024.02.05 작성',
      'comment':
          '생각보다 되게 잘마셨어요 점심 대용으로 먹기에 딱 좋았습니다 핫으로 시키면 얼음이 없어서 오래 마시기 좋아요 단 걸 별로 안 좋아하는데도 괜찮았네요',
    },
    {
      'userImage': 'assets/imgs/sample4.jpg',
      'userName': 'UU',
      'rating': 3.5,
      'date': '2024.01.15 작성',
      'comment': '원두 자체가 그냥 그렇다고 생각했는데 또 어느날 먹어보니 괜찮고 그러네요 기본적으로 얼음이 조금 더 많이 있었으면 완벽했을 것 같아요.',
    },
    // 더 많은 목업 데이터를 추가할 수 있습니다.
  ];

  int _reviewsToShow = 5; // 처음에 표시할 리뷰 개수

  void _loadMoreReviews() {
    setState(() {
      _reviewsToShow += 5; // 5개씩 더 로드
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '후기 확인하기',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image(
              image: widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // 반투명 흰색 배경
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.9)),
          ),
          // 컨텐츠
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildProductInfoSection(), // 제품 정보 섹션
                _buildReviewList(), // 리뷰 리스트 섹션
                if (_reviewsToShow < reviews.length) // 리뷰가 더 남아있을 때만 표시
                  TextButton(
                    onPressed: _loadMoreReviews,
                    child: Text(
                      '리뷰 더보기 ↓',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 제품 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.productImage,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          // 제품 정보 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brandName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${widget.averageRating}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '정가 ${widget.originalPrice} → 최저가 ${widget.discountedPrice}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    // 현재 표시할 리뷰 개수만큼만 리스트를 만듭니다.
    return Column(
      children: reviews
          .take(_reviewsToShow)
          .map((review) => _buildReviewItem(review))
          .toList(),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(review['userImage']),
                radius: 30,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['userName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildRatingStars(review['rating']),
                  SizedBox(height: 4),
                  Text(
                    review['date'],
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            review['comment'],
            style: TextStyle(fontSize: 14),
            maxLines: 2, // 두 줄까지만 표시
            overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 '...' 표시
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor(); // 완전히 채워진 별의 개수
    bool hasHalfStar = (rating - fullStars) >= 0.5; // 반만 채워진 별이 있는지 여부

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          // 완전히 채워진 별
          return Icon(Icons.star_rounded, color: Colors.orange, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          // 반만 채워진 별
          return Icon(Icons.star_half_rounded, color: Colors.orange, size: 16);
        } else {
          // 채워지지 않은 별
          return Icon(Icons.star_border_rounded,
              color: Colors.grey[300], size: 16);
        }
      }),
    );
  }
}
