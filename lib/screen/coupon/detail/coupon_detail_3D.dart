import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CouponDetail3D extends StatefulWidget {
  final String generatedPrompt;
  final String? generatedVideoUrl;

  const CouponDetail3D({
    super.key,
    required this.generatedPrompt,
    this.generatedVideoUrl,
  });

  @override
  _CouponDetail3DState createState() => _CouponDetail3DState();
}

class _CouponDetail3DState extends State<CouponDetail3D> {
  // O3DController controller = O3DController(); // 3D 모델 부분 주석 처리
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.generatedVideoUrl != null &&
        widget.generatedVideoUrl!.isNotEmpty) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.generatedVideoUrl!))
            ..initialize().then((_) {
              setState(() {}); // 화면을 업데이트해서 비디오를 표시
              _controller?.play(); // 자동 재생
            }).catchError((error) {
              print("Video loading failed: $error");
              // 실패 시 메시지 표시
              setState(() {
                _controller = null; // 실패한 경우 비디오 컨트롤러를 null로 설정
              });
            });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
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
              child: Center(
                child: _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!), // 영상 플레이어 출력
                      )
                    : widget.generatedVideoUrl == null ||
                            widget.generatedVideoUrl!.isEmpty
                        ? Text("비디오 URL이 없습니다.") // URL이 없을 때 메시지 출력
                        : Text("비디오 로딩에 실패했습니다."), // 로딩 실패 시 메시지 출력
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Center(
  //   child: SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     height: MediaQuery.of(context).size.height * 0.75,
  //     child: Stack(
  //       children: [
  //         Positioned.fill(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(15),
  //             child: Image.asset(
  //               "assets/cafe_background.png",
  //               fit: BoxFit.cover, // 배경 이미지 크기 조정
  //             ),
  //           ),
  //         ),
  //         // 3D 모델 대신 프롬프트를 화면 중앙에 출력
  //         Center(
  //           child: Text(
  //             widget.generatedPrompt, // 생성된 프롬프트를 출력
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 13,
  //               fontFamily: 'Inter',
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // ),
}
