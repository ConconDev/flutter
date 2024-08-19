import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Page1()),
        // );
        print("1번");
        break;
      case 1:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Page2()),
        // );
        print("2번");
        break;
      case 2:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Page3()),
        // );
        print("3번");
        break;
      case 3:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Page4()),
        // );
        print("4번");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF9900),
        unselectedItemColor: Color(0xFF787878),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 35,
            ),
            label: '기프티콘',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.file_upload_outlined,
              size: 35,
            ),
            label: '등록하기',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront_outlined,
              size: 35,
            ),
            label: '거래하기',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 35,
            ),
            label: '내 계정',
          ),
        ],
      ),
    );
  }
}
