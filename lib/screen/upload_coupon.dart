import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import '../config.dart';
import 'coupon/my_coupon_list.dart';
import 'navigation_bar.dart';
import 'popup_widget.dart'; // popup_widget.dart 추가

class UploadCoupon extends StatefulWidget {
  const UploadCoupon({super.key});

  @override
  _UploadCouponState createState() => _UploadCouponState();
}

class _UploadCouponState extends State<UploadCoupon> {
  File? _imageFile;
  double? _imageAspectRatio;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final ApiService apiService = ApiService();

  bool _isProcessing = false;

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
          '기프티콘 등록',
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
      body: Stack(
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
                SizedBox(height: kToolbarHeight * 1.8),
                Text(
                  '인식 오류가 있을 수 있으므로 등록 전 확인해 주십시오',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          _buildImagePicker(),
                          SizedBox(height: 30),
                          _buildTextField('바코드', _barcodeController),
                          SizedBox(height: 20),
                          _buildTextField('브랜드명', _brandController),
                          SizedBox(height: 20),
                          _buildTextField('상품명', _productNameController),
                          SizedBox(height: 20),
                          _buildTextField('유효 기간', _expiryDateController,
                              suffixIcon: Icons.calendar_today),
                          SizedBox(height: 40),
                          _buildRegisterButton(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Center(
              child: CircularProgressIndicator(
                color: Color(0xffFF8A00),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final aspectRatio = await _getImageAspectRatio(File(pickedFile.path));
          setState(() {
            _imageFile = File(pickedFile.path);
            _imageAspectRatio = aspectRatio;
            _isProcessing = true;
          });
          await _extractTextFromImage();
          setState(() {
            _isProcessing = false;
          });
        }
      },
      child: _imageFile == null
          ? Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.grey[800],
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: _imageAspectRatio ?? 1.0,
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }

  Future<double> _getImageAspectRatio(File imageFile) async {
    final image = Image.file(imageFile);
    final completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    final size = await completer.future;
    return size.width / size.height;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? suffixIcon,
    String? customHintText,
  }) {
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
        SizedBox(height: 15),
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
            controller: controller,
            readOnly: suffixIcon != null,
            enabled: _imageFile != null, // 이미지가 없으면 수정 불가
            onTap: suffixIcon != null ? () => _selectDate(context) : null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _imageFile != null
                  ? (controller.text.isEmpty
                      ? customHintText ?? '인식되지 않았습니다. 직접 입력해주세요'
                      : '이미지 등록 이후 수정 가능합니다')
                  : '이미지 등록 이후 수정 가능합니다',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ), // 세로 중앙 정렬
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
          height: 2,
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _expiryDateController.text.isNotEmpty
        ? DateTime.tryParse(_expiryDateController.text) ?? DateTime.now()
        : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'),
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF404040), // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Color(0xFF404040), // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF404040), // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
    if (picked != null && picked != initialDate) {
      setState(() {
        _expiryDateController.text =
            "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_imageFile == null) {
      print('No image file selected');
      return;
    }

    const apiUrl = 'https://api.ocr.space/parse/image';
    const apiKey = Config.ocrSpaceApiKey;

    try {
      setState(() {
        _isProcessing = true; // 시작할 때 로딩 상태로 전환
        print('Processing started...');
      });

      // 이미지 파일을 읽고 Base64로 인코딩
      final bytes = _imageFile!.readAsBytesSync();
      print('Image file read successfully');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'apikey': apiKey,
        },
        body: {
          'base64image': 'data:image/png;base64,${base64Encode(bytes)}',
          'language': 'kor', // 한국어로 설정
        },
      );

      print('OCR request sent, status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('OCR response: $result');

        if (result['ParsedResults'] != null &&
            result['ParsedResults'].length > 0) {
          final text = result['ParsedResults'][0]['ParsedText'];
          print('Parsed text: $text');

          String? barcode;
          String? productName;
          String? expiryDate;
          String? brandName;

          final brandCount = <String, int>{};

          // 각 정보를 추출하는 로직
          final lines = (text.split('\n') as List<String>)
              .where((String line) => line.trim().isNotEmpty)
              .toList();

          if (lines.isNotEmpty) {
            brandName = lines[0].trim(); // 첫 번째 줄을 브랜드명으로 설정

            if (lines.length > 1) {
              productName = lines[1].trim(); // 두 번째 줄을 상품명으로 설정
            }

            bool expiryDateFound = false;

            for (var line in lines) {
              line = line.trim();

              if (!expiryDateFound &&
                  (RegExp(r'^20\d{6}$').hasMatch(line) ||
                      RegExp(r'^20[\d\s\W]{6}$').hasMatch(line))) {
                expiryDate = line.replaceAll(RegExp(r'\D'), '0');
                expiryDate =
                    "${expiryDate.substring(0, 4)}.${expiryDate.substring(4, 6)}.${expiryDate.substring(6, 8)}";
                expiryDateFound = true;
              }

              if (RegExp(r'^(\d{4}\s){2}\d{4}$').hasMatch(line) ||
                  RegExp(r'^\d{13}$').hasMatch(line)) {
                barcode = line.replaceAll(' ', '');
              }

              brandCount[line] = (brandCount[line] ?? 0) + 1;
              if (brandCount[line]! >= 2) {
                brandName = line;
              }
            }

            if (!expiryDateFound && lines.length > 1) {
              var line = lines[lines.length - 2].trim();
              expiryDate = line.replaceAll(RegExp(r'\D'), '0');
              expiryDate =
                  "${expiryDate.substring(0, 4)}.${expiryDate.substring(4, 6)}.${expiryDate.substring(6, 8)}";
            }
          }

          if (mounted) {
            setState(() {
              _barcodeController.text = barcode ?? '';
              _productNameController.text = productName ?? '';
              _expiryDateController.text = expiryDate ?? '';
              _brandController.text = brandName ?? '';
              _isProcessing = false;
            });

            print('Data updated successfully');
          }
        } else {
          print('No parsed results found in the OCR response');
        }
      } else {
        print("OCR request failed with status: ${response.statusCode}");
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      print("OCR error: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // 상품명으로 item details 검색
          String productName = _productNameController.text.trim();
          String barcode = _barcodeController.text.trim();
          String expirationDate = _expiryDateController.text.trim();

          if (productName.isNotEmpty) {
            Map<String, dynamic>? itemDetails =
                await apiService.fetchItemDetails(productName);

            if (itemDetails != null) {
              int itemId = itemDetails['itemId'];
              String brand = itemDetails['brand'];
              dynamic priceValue = itemDetails['price'];
              int price;

              if (priceValue is double) {
                price = priceValue.toInt();
              } else if (priceValue is int) {
                price = priceValue;
              } else {
                throw Exception("Invalid price type");
              }

              // itemId가 성공적으로 검색된 경우
              showDialog(
                context: context,
                builder: (context) {
                  return ChoicePopupWidget(
                    message: '${brand}의 ${productName} 쿠폰을 등록하시겠습니까?',
                    onConfirm: () async {
                      // 쿠폰 등록 API 호출
                      bool? success = await apiService.registerCoupon(
                        itemId,
                        barcode,
                        productName,
                        expirationDate,
                        price,
                      );

                      if (mounted) {
                        // API 호출 결과에 따라 팝업 표시
                        showDialog(
                          context: context,
                          builder: (context) {
                            if (success == true) {
                              return SimpleAlertPopupWidget(
                                message: '쿠폰 등록에 성공했습니다',
                                onConfirm: () {
                                  // 팝업 닫고 쿠폰 리스트로 이동
                                  Navigator.of(context).pop(); // 팝업 닫기
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyCouponList(),
                                    ),
                                  );
                                },
                              );
                            } else if (success == false) {
                              return SimpleAlertPopupWidget(
                                message: '쿠폰 등록에 실패했습니다',
                                onConfirm: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                              );
                            } else {
                              // success가 null인 경우 (네트워크 오류 등)
                              return SimpleAlertPopupWidget(
                                message: '오류가 발생했습니다\n다시 시도해 주세요',
                                onConfirm: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                },
              );
            } else {
              // itemId 검색 실패
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleAlertPopupWidget(
                    message: '상품을 찾을 수 없습니다.',
                  );
                },
              );
            }
          } else {
            // 상품명이 입력되지 않은 경우
            showDialog(
              context: context,
              builder: (context) {
                return SimpleAlertPopupWidget(
                  message: '상품명을 입력해주세요.',
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF8A00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          '등록하기',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
