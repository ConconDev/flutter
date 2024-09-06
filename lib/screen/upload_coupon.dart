import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'navigation_bar.dart';

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

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation:0,
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
                SizedBox(height: kToolbarHeight * 2.2),
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
              child: CircularProgressIndicator(color: Color(0xffFF8A00),),
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
        ),SizedBox(height: 2,)
      ],
    );
  }


Future<void> _selectDate(BuildContext context) async {
  // 현재 유효기간이 있는 경우, 해당 날짜를 초기 날짜로 설정
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
      // 날짜 형식이 잘못된 경우, 현재 날짜를 초기 날짜로 사용
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
      _expiryDateController.text = "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
    });
  }
}

 Future<void> _extractTextFromImage() async {
  if (_imageFile == null) return;

  const apiUrl = 'https://api.ocr.space/parse/image';
  const apiKey = Config.ocrSpaceApiKey;

  try {
    final bytes = _imageFile!.readAsBytesSync();
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

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['ParsedResults'] != null &&
          result['ParsedResults'].length > 0) {
        final text = result['ParsedResults'][0]['ParsedText'];


        print(text);

        String? barcode;
        String? productName;
        String? expiryDate;
        String? brandName;

        final brandCount = <String, int>{};

        // 각 정보를 추출하는 로직
      final lines = (text.split('\n') as List<String>).where((String line) => line.trim().isNotEmpty).toList();



        if (lines.isNotEmpty) {
          brandName = lines[7].trim(); // 첫 번째 줄을 브랜드명으로 설정

          if (lines.length > 1) {
            productName = lines[1].trim(); // 두 번째 줄을 상품명으로 설정
          }

          bool expiryDateFound = false;

          for (var line in lines) {
            line = line.trim();

            // 유효기간: 8자리 숫자 중 "20"으로 시작하는 것
            if (!expiryDateFound &&
                (RegExp(r'^20\d{6}$').hasMatch(line) ||
                    RegExp(r'^20[\d\s\W]{6}$').hasMatch(line))) {
              // 날짜에서 숫자가 아닌 문자를 "0"으로 대체
              expiryDate = line.replaceAll(RegExp(r'\D'), '0');
              expiryDate =
                  "${expiryDate.substring(0, 4)}.${expiryDate.substring(4, 6)}.${expiryDate.substring(6, 8)}";
              expiryDateFound = true;
            }

            // 바코드: 4자리씩 끊어진 숫자 또는 13자리 숫자
            if (RegExp(r'^(\d{4}\s){2}\d{4}$').hasMatch(line) ||
                RegExp(r'^\d{13}$').hasMatch(line)) {
              barcode = line.replaceAll(' ', '');
            }

            // 브랜드명: 두 번 이상 반복되는 텍스트를 브랜드명으로 설정
            brandCount[line] = (brandCount[line] ?? 0) + 1;
            if (brandCount[line]! >= 2) {
              brandName = line;
            }
          }

          // 유효기간이 아직 설정되지 않았다면, 마지막에서 두 번째 줄을 유효기간으로 설정
          if (!expiryDateFound && lines.length > 1) {
            var line = lines[lines.length - 2].trim();
            expiryDate = line.replaceAll(RegExp(r'\D'), '0');
            expiryDate =
                "${expiryDate.substring(0, 4)}.${expiryDate.substring(4, 6)}.${expiryDate.substring(6, 8)}";
          }
        }

        setState(() {
          _barcodeController.text = barcode ?? '';
          _productNameController.text = productName ?? '';
          _expiryDateController.text = expiryDate ?? '';
          _brandController.text = brandName ?? '';
        });
      }
    } else {
      print("OCR request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("OCR error: $e");
  }
}


  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
         onPressed: () {
        // 바코드 생성 및 팝업으로 표시해 테스트 -> 나중에 API 연결 시 이미지로 전송
        if (_barcodeController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('생성된 바코드'),
                content: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: _barcodeController.text,
                  width: 200,
                  height: 80,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('닫기'),
                  ),
                ],
              );
            },
          );
        } else {
          // 바코드가 없을 때 처리
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('오류'),
                content: Text('바코드 데이터가 없습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                  ),
                ],
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
