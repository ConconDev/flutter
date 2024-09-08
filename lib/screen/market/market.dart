import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../navigation_bar.dart';
import 'market_sale.dart';
import 'transaction_history.dart';
import 'user_profile.dart'; // user_profile.dart import 추가

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late final WebViewController _controller;
  bool isWebViewLoaded = false;
  bool isWebViewPaused = false; // 웹뷰가 멈춰있는 상태를 나타내는 변수
  bool isLoading = false; // 화면 전환 로딩 상태 변수 추가
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  final LayerLink _layerLink = LayerLink(); // LayerLink 생성
  OverlayEntry? _overlayEntry; // OverlayEntry 참조

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _initializeCamera(); // 카메라 초기화 추가
  }

  // 웹뷰 초기화 함수
  void _initializeWebView() {
  _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel(
      'onBoxClick',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message); // 메시지 처리 함수 호출
      },
    )
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
          if (progress == 100) {
            setState(() {
              isWebViewLoaded = true; // 로딩이 완료되면 인디케이터를 숨깁니다.
            });
          }
        },
        onPageStarted: (String url) {
          setState(() {
            isWebViewLoaded = false; // 페이지가 다시 시작되면 로딩을 표시합니다.
          });
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          setState(() {
            isWebViewLoaded = true; // 페이지 로딩이 끝나면 인디케이터를 숨깁니다.
          });
        },
        onWebResourceError: (WebResourceError error) {
          print('''
          Page resource error:
          Code: ${error.errorCode}
          Description: ${error.description}
          ErrorType: ${error.errorType}
          ''');
        },
      ),
    );

  // 초기화 지연을 추가하여 카메라 초기화 이후에 웹뷰 로딩을 시작하도록 합니다.
  Future.delayed(Duration(milliseconds: 200), _loadHtml);
}

  // JavaScript 메시지 처리 함수
  void _handleJavaScriptMessage(String message) async {
    switch (message) {
      case '판매중 박스 1 클릭됨':
      case '판매중 박스 2 클릭됨':
        print('판매중 박스가 클릭되었습니다.');
        _navigateToUserProfileScreen(context, isSaleTab: true); // 판매 상품 화면으로 전환
        break;
      case '후기 박스 1 클릭됨':
      case '후기 박스 2 클릭됨':
        print('후기 박스가 클릭되었습니다.');
        _navigateToUserProfileScreen(context, isSaleTab: false); // 리뷰 목록 화면으로 전환
        break;
      default:
        print('알 수 없는 박스가 클릭되었습니다.');
    }
  }

  // UserProfileScreen으로 전환하는 함수
  void _navigateToUserProfileScreen(BuildContext context, {required bool isSaleTab}) {
    _navigateWithLoadingIndicator(
      context,
      (imageProvider) => UserProfileScreen(
        backgroundImage: imageProvider,
        initialTab: isSaleTab ? 0 : 1, // 탭 인덱스를 전달 (0: 판매 상품, 1: 리뷰 목록)
      ),
    );
  }

  // 화면 전환 시 로딩 인디케이터 표시 및 상태 관리 함수
  Future<void> _navigateWithLoadingIndicator(
      BuildContext context, Widget Function(FileImage) screenBuilder) async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        // 카메라 화면 캡처
        final image = await _cameraController!.takePicture();
        final File imageFile = File(image.path); // 캡처된 이미지를 File로 저장

        // 파일이 실제로 존재하는지 확인
        if (!await imageFile.exists()) {
          print('Error: Captured image file does not exist.');
          setState(() {
            isLoading = false; // 로딩 종료
          });
          return;
        }

        final FileImage imageProvider = FileImage(imageFile);

        if (!mounted) {
          setState(() {
            isLoading = false; // 로딩 종료
          });
          return; // 화면이 사라졌을 때 예외 방지
        }

        // 웹뷰와 카메라 프리뷰 일시정지
        _pauseWebView();
        _pauseCameraPreview();

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => screenBuilder(imageProvider), // 화면 전환
          ),
        );

        _resumeWebView(); // 화면에서 돌아올 때 웹뷰 다시 시작
        _resumeCameraPreview(); // 카메라 프리뷰 다시 시작
      } catch (e) {
        print('Error while navigating: $e');
      } finally {
        setState(() {
          isLoading = false; // 로딩 종료
        });
      }
    }
  }

  // 판매 화면 전환 함수
  void _navigateToSaleScreen(BuildContext context) {
    _navigateWithLoadingIndicator(
        context, (imageProvider) => MarketSaleScreen(backgroundImage: imageProvider));
  }

  // 거래 내역 확인 화면으로 전환하는 함수
  void _navigateToTransactionHistoryScreen(BuildContext context) {
    _navigateWithLoadingIndicator(
        context, (imageProvider) => TransactionHistoryScreen(backgroundImage: imageProvider));
  }


// HTML 로드 함수
void _loadHtml() async {
  // 웹뷰 로딩을 더 최적화하고 비동기 처리합니다.
  try {
    await _controller.loadFlutterAsset('assets/babylon_view.html');
    print("WebView HTML loaded.");
  } catch (e) {
    print("Failed to load HTML: $e");
  }
}
  // 카메라 프리뷰를 화면에 맞추는 위젯 수정
  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size; // 화면 크기
    final deviceRatio = size.height / size.width; // 화면 비율 반전
    final previewRatio = _cameraController!.value.aspectRatio; // 카메라 프리뷰 비율

    return Transform.scale(
      scale: deviceRatio > previewRatio
          ? deviceRatio / previewRatio
          : previewRatio / deviceRatio, // 화면에 맞게 스케일 조정
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / _cameraController!.value.aspectRatio, // 비율 반전
          child: CameraPreview(_cameraController!), // 카메라 프리뷰 위젯
        ),
      ),
    );
  }

  // 카메라 초기화 함수
  Future<void> _initializeCamera() async {
    cameras = await availableCameras(); // 사용 가능한 카메라 목록 가져오기
    if (cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras!.first,
        ResolutionPreset.max, // 해상도 높게 설정
        imageFormatGroup: ImageFormatGroup.jpeg, // 이미지 포맷 설정
      );

      // 카메라 컨트롤러 초기화
      await _cameraController!.initialize();

      // 세로 모드 고정 설정
      if (_cameraController!.description.lensDirection == CameraLensDirection.front) {
        await _cameraController!.setFocusMode(FocusMode.auto);
      }

      setState(() {}); // 카메라 초기화 후 화면 재렌더링
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // 카메라 컨트롤러 해제
    _removeOverlay(); // OverlayEntry 제거
    super.dispose();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _resumeCameraPreview(); // 팝업 닫힐 때 카메라 다시 시작
      _resumeWebView(); // 웹뷰 다시 시작
    }
  }

  void _pauseCameraPreview() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      _cameraController!.pausePreview();
    }
  }

  void _resumeCameraPreview() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      _cameraController!.resumePreview();
    }
  }

  void _pauseWebView() {
    if (!isWebViewPaused) {
      _controller.runJavaScript("document.body.style.display = 'none';"); // 웹뷰 내용 숨기기
      setState(() {
        isWebViewPaused = true;
      });
    }
  }

  void _resumeWebView() {
    if (isWebViewPaused) {
      _controller.runJavaScript("document.body.style.display = 'block';"); // 웹뷰 내용 보이기
      setState(() {
        isWebViewPaused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          // Builder로 감싸서 새로운 context 제공
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 20),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.refresh,
                color: Colors.black54.withOpacity(0.7),
                size: 28,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Drawer 열기
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black54.withOpacity(0.7),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add_business_outlined,
              color: Colors.black54.withOpacity(0.7),
            ),
            onPressed: () {
              _navigateToSaleScreen(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.format_list_numbered,
              color: Colors.black54.withOpacity(0.7),
            ),
            onPressed: () {
              _navigateToTransactionHistoryScreen(context); // TransactionHistoryScreen으로 전환
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      drawer: _buildDrawer(),
      onDrawerChanged: (isOpened) {
        // Drawer 열림/닫힘 상태 감지
        if (isOpened) {
          _pauseCameraPreview(); // Drawer가 열릴 때 카메라 멈춤
          _pauseWebView(); // Drawer가 열릴 때 웹뷰 멈춤
        } else {
          _resumeCameraPreview(); // Drawer가 닫힐 때 카메라 재개
          _resumeWebView(); // Drawer가 닫힐 때 웹뷰 재개
        }
      },
      bottomNavigationBar: CustomNavigationBar(currentIndex: 2),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
              child: _buildCameraPreview(), // 수정된 카메라 프리뷰 위젯 사용
            ),
          if (isWebViewLoaded)
            Positioned.fill(
              child: WebViewWidget(controller: _controller), // 웹뷰 위젯
            ),
          if (!isWebViewLoaded)
            const Center(
                child: CircularProgressIndicator(
              color: Colors.black54,
            )), // 로딩 인디케이터
          if (isLoading) // 로딩 상태일 때 로딩 인디케이터 표시
            Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }

  // Drawer 위젯 빌드 함수
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white, // 배경색 흰색으로 설정
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 padding 추가
        children: [
          const SizedBox(height: 50),
          _buildDrawerSectionTitle('화면 전환', centered: true), // 가운데 정렬
          Divider(), // 유저 바꾸기 위에 구분선 추가
          _buildDrawerItem('유저 바꾸기', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
          Divider(), // 구분선 추가
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: _buildDrawerSectionTitle('카테고리 바꾸기'),
          ),
          _buildDrawerItem('카페 · 디저트', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
          _buildDrawerItem('영화 · 엔터테인먼트', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
          _buildDrawerItem('치킨 · 패스트푸드', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
          _buildDrawerItem('편의점 · 마트', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
          _buildDrawerItem('여행 · 숙박', onTap: () {
            Navigator.pop(context); // Drawer 닫기
            _resumeCameraPreview();
            _resumeWebView();
          }),
        ],
      ),
    );
  }

  // 섹션 제목 빌드 함수
  Widget _buildDrawerSectionTitle(String title, {bool centered = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        textAlign: centered ? TextAlign.center : TextAlign.left, // 가운데 정렬 옵션 추가
      ),
    );
  }

  // Drawer 아이템 빌드 함수
  Widget _buildDrawerItem(String title, {required Function() onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right), // 우측 화살표 아이콘 추가
      onTap: onTap,
    );
  }
}
