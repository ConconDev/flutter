import 'package:concon/screen/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, //디버그 바 제거
    home: LoginPage(),
  ));
}
