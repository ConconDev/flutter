import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class WriteReview extends StatefulWidget {
  final String image;
  final String brand;
  final String productName;
  final String date;

  const WriteReview({
    Key? key,
    required this.image,
    required this.brand,
    required this.productName,
    required this.date,
  }) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFFFAF04),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '리뷰 작성',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFFAF04),
                    Color(0xFFFFE895),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight * 2.2),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
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
                                      image: AssetImage(widget.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 27),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 23),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15,20,20,20),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                         padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.brand,
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
                                            widget.productName,
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
                                            '${widget.date} 사용 완료',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        _buildRatingStars(),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: TextField(
                                            scrollPadding:
                                                EdgeInsets.only(bottom: 150),
                                            controller: _reviewController,
                                            maxLines: null,
                                            maxLength: 1000,
                                            decoration: InputDecoration(
                                              hintText: '솔직한 리뷰로 나만의 평가를 남겨보세요',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              border: InputBorder.none,
                                            ),
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
                                ),
                                SizedBox(height: 150),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.white.withOpacity(0.6),
                    height: 70,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 50,
              bottom: 25,
              child: ElevatedButton(
                onPressed: () {
                  // 저장 버튼 눌렀을 때 처리
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF8A00),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _rating = index + 1.0;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _rating =
                    (index + details.localPosition.dx / 30).clamp(0.0, 5.0);
              });
            },
            child: Icon(
              _rating >= index + 1
                  ? Icons.star_rounded
                  : _rating > index
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              color: Color(0xff484848),
              size: 40,
            ),
          );
        },
      ),
    );
  }
}
