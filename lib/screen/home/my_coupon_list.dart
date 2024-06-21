import 'package:flutter/material.dart';

class MyCouponList extends StatelessWidget {
  const MyCouponList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '기프티콘 목록',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            SizedBox(
              height: 132,
            ),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: Image.asset('assets/user/user_image_sample.png'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text("이름"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
