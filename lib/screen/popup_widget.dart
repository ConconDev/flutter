import 'package:flutter/material.dart';

class PopupWidget extends StatelessWidget {
  final String message;
  final bool success;

  const PopupWidget({required this.message, required this.success, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: success ? Color(0xFFFF9F0E) : Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: success ? FontWeight.bold : FontWeight.w400,
                      color: success ? Color(0xFFFFFFFF) : Color(0xFF484848),
                      letterSpacing: -0.36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Page()),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          success ? Color(0xFFFFFFFF) : Color(0xFF484848),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              success ? Color(0xFFFF9F0E) : Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
