import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class CouponDetail3D extends StatefulWidget {
  const CouponDetail3D({super.key});

  @override
  _CouponDetail3DState createState() => _CouponDetail3DState();
}

class _CouponDetail3DState extends State<CouponDetail3D> {
  O3DController controller = O3DController();

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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/cafe_background.png",
                            fit: BoxFit.cover, // 배경 이미지 크기 조정
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: O3D.asset(
                            src: 'assets/Starbucks.glb',
                            controller: controller,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
