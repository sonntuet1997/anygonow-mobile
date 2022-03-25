import 'package:flutter/material.dart';
import 'package:untitled/utils/config.dart';

class MyProjectScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Request",
          style: TextStyle(
            color: Colors.black,
            fontSize: getWidth(24),
            fontWeight: FontWeight.w700,
          ),
        ),
        shadowColor: Color(0xFFE5E5E5),
        backgroundColor: Colors.white,
      ),
    );
  }
}
