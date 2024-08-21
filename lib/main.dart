import 'package:concon/screen/home/my_coupon_list.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Color(0xFFFF9900),
            selectionHandleColor: Color(0xFFFF9900),
          ),
        ),
    home: MyCouponList(),
  ));
}
