import 'package:flutter/material.dart';
import '../../../api_service.dart'; // ApiService 가져오기

class CouponDetailChat extends StatefulWidget {
  final String productName;
  final String brand;

  const CouponDetailChat(
      {super.key, required this.productName, required this.brand});
  @override
  _CouponDetailChatState createState() => _CouponDetailChatState();
}

class _CouponDetailChatState extends State<CouponDetailChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성
  List<Map<String, String>> conversationHistory = []; // 대화 기록 저장
  String? summary; // 요약된 대화 저장 변수

  // 스크롤을 프레임이 렌더링된 후에 실행
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 메시지 보내기 함수
  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': message});
        _controller.clear();
      });

      _scrollToBottom();

      // 메시지를 대화 기록에 추가
      conversationHistory.add({'role': 'user', 'content': message});

      String gifticonInfo = "${widget.brand} ${widget.productName}";

      try {
        // ChatGPT에 메시지 전송 및 요약 포함
        String result = await _apiService.searchGoogleCustom(gifticonInfo);
        String botResponse =
            await _apiService.getChatbotResponse(message, result);

        setState(() {
          _messages.add({'sender': 'bot', 'text': botResponse});
          conversationHistory
              .add({'role': 'assistant', 'content': botResponse});
        });

        _scrollToBottom();

        // 대화가 5개 이상일 경우 요약
        if (conversationHistory.length >= 5) {
          summary =
              await _apiService.summarizeConversation(conversationHistory);
          conversationHistory.clear(); // 요약 후 기록 초기화
        }
      } catch (error) {
        setState(() {
          _messages
              .add({'sender': 'bot', 'text': '서버 오류가 발생했습니다. 다시 시도해 주세요.'});
        });
        _scrollToBottom();
      }
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUserMessage = message['sender'] == 'user';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUserMessage)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset(
                'assets/icon/AIIcon.png',
                width: 24,
                height: 24,
              ),
            ),
          Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUserMessage ? Color(0xFFFFAF04) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Text(
                  message['text']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: isUserMessage ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          '챗봇에게 물어보기',
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
        child: Container(
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        'ChatGPT를 활용한 AI 챗봇에게 해당 제품에 관해 물어볼 수 있습니다',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            letterSpacing: -0.15),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: 50,
                          child: Divider(
                            thickness: 1,
                            color: Colors.orange,
                          )),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessage(_messages[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          SizedBox(
            width: 7,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFFAF04),
                    Color(0xFFFFCB4A),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                cursorErrorColor: Colors.white,
                onSubmitted: (value) {
                  _sendMessage();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  hintText: '챗봇에게 궁금한 내용을 질문해보세요!',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.white,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(14),
              backgroundColor: Color(0xFFFF8A00),
            ),
            child: Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
