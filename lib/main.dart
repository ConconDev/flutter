import 'package:concon/screen/home/my_coupon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await FlutterConfig.loadEnvVariables();
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
