import 'package:flutter/material.dart';

class SignTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?)? validator;

  const SignTextField({
    required this.controller,
    required this.hintText,
    required this.isPassword,
    required this.isPasswordVisible,
    this.onVisibilityToggle,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: Color(0xFFFF9900),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xFFFF9900),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFFFF9900),
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
