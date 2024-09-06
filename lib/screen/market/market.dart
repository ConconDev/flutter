import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // 카메라 플러그인 추가
import 'package:webview_flutter/webview_flutter.dart'; // 웹뷰 플러그인 추가
import '../navigation_bar.dart'; // 네비게이션 바 추가

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late final WebViewController _controller;
  bool isWebViewLoaded = false;
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
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isWebViewLoaded = true;
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

    _loadHtml();
  }

  // JavaScript 메시지 처리 함수
  void _handleJavaScriptMessage(String message) {
    switch (message) {
      case '판매중 박스 1 클릭됨':
        print('판매중 첫 번째 박스가 클릭되었습니다.');
        break;
      case '판매중 박스 2 클릭됨':
        print('판매중 두 번째 박스가 클릭되었습니다.');
        break;
      case '후기 박스 1 클릭됨':
        print('후기 첫 번째 박스가 클릭되었습니다.');
        break;
      case '후기 박스 2 클릭됨':
        print('후기 두 번째 박스가 클릭되었습니다.');
        break;
      default:
        print('알 수 없는 박스가 클릭되었습니다.');
    }
  }

  // HTML 로드 함수
  void _loadHtml() async {
    await _controller.loadFlutterAsset('assets/babylon_view.html');
  }

  // 카메라 초기화 함수
  Future<void> _initializeCamera() async {
    cameras = await availableCameras(); // 사용 가능한 카메라 목록 가져오기
    if (cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras!.first,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
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

  void _showCustomMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _removeOverlay(); // 기존 OverlayEntry 제거
      return;
    }

    _pauseCameraPreview(); // 팝업 열릴 때 카메라 멈추기

    final overlay = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent, // 터치 이벤트가 감지되도록 설정
        onTap: () {
          _removeOverlay(); // 팝업 외부를 눌렀을 때 팝업 제거
        },
        child: Stack(
          children: [
            Positioned(
              width: 140, // 팝업 너비 설정
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-90, 50), // 아이콘 바로 아래에 위치하도록 오프셋 설정 (왼쪽으로 조정)
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild, // 자식 위젯의 터치 이벤트가 우선되도록 설정
                    onTap: () {}, // 팝업 내 터치 시 닫히지 않도록 빈 콜백 사용
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7), // 배경색 흰색에 투명도 70%
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch, // 전체 너비에 맞춰서 가운데 정렬
                        children: [
                          InkWell( // InkWell로 각 메뉴 항목을 감싸서 터치 이벤트를 쉽게 처리
                            onTap: () {
                              print('기프티콘 판매 선택됨');
                              _removeOverlay(); // 메뉴 항목 선택 시 팝업 닫기
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                              child: Text(
                                '기프티콘 판매',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              ),
                            ),
                          ),
                          Divider(height: 1, thickness: 1, color: Colors.grey[300]), // 구분선
                          InkWell( // 두 번째 메뉴 항목도 InkWell로 감싸기
                            onTap: () {
                              print('거래 내역 확인 선택됨');
                              _removeOverlay(); // 메뉴 항목 선택 시 팝업 닫기
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                              child: Text(
                                '거래 내역 확인',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder( // Builder로 감싸서 새로운 context 제공
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
          CompositedTransformTarget(
            link: _layerLink,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black54.withOpacity(0.7),
              ),
              onPressed: () {
                _showCustomMenu(context); // 메뉴 표시 함수 호출
              },
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      drawer: _buildDrawer(),
      onDrawerChanged: (isOpened) { // Drawer 열림/닫힘 상태 감지
        if (isOpened) {
          _pauseCameraPreview(); // Drawer가 열릴 때 카메라 멈춤
        } else {
          _resumeCameraPreview(); // Drawer가 닫힐 때 카메라 재개
        }
      },
      bottomNavigationBar: CustomNavigationBar(currentIndex: 2),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!),  // 카메라 프리뷰 위젯
          if (isWebViewLoaded)
            WebViewWidget(controller: _controller),  // 웹뷰 위젯
          if (!isWebViewLoaded)
            const Center(child: CircularProgressIndicator()),  // 로딩 인디케이터
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
            // 유저 바꾸기 로직
          }),
          Divider(), // 구분선 추가
          Padding(
            padding: const EdgeInsets.fromLTRB(15,10,0,10),
            child: _buildDrawerSectionTitle('카테고리 바꾸기'),
          ),
          _buildDrawerItem('카페 · 디저트', onTap: () {
            // 카테고리 변경 로직
          }),
          _buildDrawerItem('영화 · 엔터테인먼트', onTap: () {
            // 카테고리 변경 로직
          }),
          _buildDrawerItem('치킨 · 패스트푸드', onTap: () {
            // 카테고리 변경 로직
          }),
          _buildDrawerItem('편의점 · 마트', onTap: () {
            // 카테고리 변경 로직
          }),
          _buildDrawerItem('여행 · 숙박', onTap: () {
            // 카테고리 변경 로직
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
