import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/global_controller.dart';
import 'package:untitled/screen/main/main_screen.dart';
import 'package:untitled/screen/user/user_screen.dart';
import 'package:untitled/widgets/bottom_navigator.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigator(),
      body: PageView(
        controller: Get.put(GlobalController()).pageController,
        children: [
          MainScreen(),
          UserScreen(),
        ],
      ),
    );
  }
}
