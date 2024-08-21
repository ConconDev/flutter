// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:ui';

import '../popup_widget.dart';

class WriteReview extends StatefulWidget {
  final String image;
  final String brand;
  final String productName;
  final String date;
  final double? initialRating;
  final String? initialReviewText;
  final bool isEditMode;

  const WriteReview({
    super.key,
    required this.image,
    required this.brand,
    required this.productName,
    required this.date,
    this.initialRating,
    this.initialReviewText,
    this.isEditMode = false, // 기본값은 false로, 작성 모드로 설정
  });

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      // 수정일 경우 초기 데이터 설정
      _rating = widget.initialRating ?? 0.0;
      _reviewController.text = widget.initialReviewText ?? '';
    }
  }

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
          widget.isEditMode ? '리뷰 수정' : '리뷰 작성',
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
        actions: widget.isEditMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // 삭제 버튼 눌렀을 때 처리
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChoicePopupWidget(
                          message: "삭제 시 복구가 불가능합니다\n이 후기를 정말 삭제하시겠습니까?",
                          onConfirm: () {
                            // 삭제 로직 구현
                            print("리뷰 삭제됨");
                          },
                        );
                      },
                    );
                  },
                )
              ]
            : null,
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
                                    padding:
                                        EdgeInsets.fromLTRB(15, 20, 20, 20),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
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
                  if (widget.isEditMode) {
                    // 수정 모드에서의 처리
                    _updateReview();
                  } else {
                    // 작성 모드에서의 처리
                    _saveReview();
                  }
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
                  widget.isEditMode ? '수정하기' : '저장하기',
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

  void _saveReview() {
    // 리뷰 저장 로직 구현
  }

  void _updateReview() {
    // 리뷰 수정 로직 구현
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
