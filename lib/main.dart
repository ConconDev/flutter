import 'package:concon/screen/3d_test.dart';
import 'package:concon/screen/on_boarding/sign_in.dart';
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
    home: SignInPage(),
  ));
}
