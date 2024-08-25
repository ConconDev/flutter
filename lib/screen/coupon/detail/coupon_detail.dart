import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'coupon_detail_3D.dart';
import 'coupon_detail_chat.dart';

class CouponDetail extends StatefulWidget {
  final String image;
  final String barcode;
  final String productName;
  final String brand;
  final String expiryDate;
  final String price;
  final List<String> categories;

  CouponDetail({
    required this.image,
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.expiryDate,
    required this.price,
    required this.categories,
  });

  @override
  _CouponDetailState createState() => _CouponDetailState();
}

class _CouponDetailState extends State<CouponDetail> {
  late TextEditingController _barcodeController;
  late TextEditingController _productNameController;
  late TextEditingController _expiryDateController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late List<String> _categories;
  int _currentIndex = 0;
  final List<String> _titles = ["기프티콘 상세", "3D 상세", "챗봇에게 물어보기"];

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.barcode);
    _productNameController = TextEditingController(text: widget.productName);
    _expiryDateController = TextEditingController(text: widget.expiryDate);
    _brandController = TextEditingController(text: widget.brand);
    _priceController = TextEditingController(text: widget.price);
    _categories = List.from(widget.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titles[_currentIndex],
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
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            color: Colors.white,
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'original',
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('원본 보기'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('삭제하기'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'support',
                  child: Row(
                    children: [
                      Icon(Icons.contact_support, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('문의하기'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildDetailPage(),
          CouponDetail3D(), // 3D 페이지
          CouponDetailChat(), // 챗봇 페이지
        ],
      ),
    );
  }

  Widget _buildDetailPage() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF8A00),
                  Color(0xFFFFE895),
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight * 2.2),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                widget.image,
                                height: MediaQuery.of(context).size.width * 0.9,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 20),
                            BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: _barcodeController.text,
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 100,
                            ),
                            SizedBox(height: 20),
                            _buildEditableField('바코드', _barcodeController),
                            SizedBox(height: 20),
                            _buildEditableField('금액', _priceController),
                            SizedBox(height: 20),
                            _buildEditableField('상품명', _productNameController),
                            SizedBox(height: 20),
                            _buildEditableField('사용 매장', _brandController),
                            SizedBox(height: 20),
                            _buildEditableField('유효 기간', _expiryDateController,
                                suffixIcon: Icons.calendar_today),
                            SizedBox(height: 20),
                            _buildCategoryField(),
                            SizedBox(height: 20),
                            _buildMemoField(),
                            SizedBox(height: 40),
                            _buildActionButtons(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF484848),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: TextField(
            controller: controller,
            readOnly: suffixIcon != null,
            onTap: suffixIcon != null ? () => _selectDate(context) : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              suffixIconConstraints: BoxConstraints(),
              suffixIcon: suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      color: Colors.grey,
                    )
                  : null,
            ),
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF484848),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '카테고리를 입력하세요',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onSubmitted: (text) {
              setState(() {
                if (text.isNotEmpty && !_categories.contains(text)) {
                  _categories.add(text);
                }
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _categories.map((category) {
            return Chip(
              backgroundColor: Colors.white,
              label: Text(category),
              onDeleted: () {
                setState(() {
                  _categories.remove(category);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메모',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF484848),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TextField(
            maxLines: 5,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: '메모를 입력하세요',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // 저장하기 로직 추가
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF8A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15),
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
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // 사용 완료 로직 추가
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFAF04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              '사용 완료',
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    if (_expiryDateController.text.isNotEmpty) {
      try {
        List<String> dateParts = _expiryDateController.text.split('.');
        initialDate = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        );
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        _expiryDateController.text =
            "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }
}
