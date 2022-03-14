import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/model/User.dart';
import 'package:untitled/model/custom_dio.dart';

class State {
  String? id;
  String? name;
}

class Category {
  String id = "";
  String name = "";
  int numberOrder = 0;
  String image = "";
}

class GlobalController extends GetxController {
  var db;
  Rx<User> user = User().obs;
  RxList<Category> categories = <Category>[].obs;
  var sharingStatus = "SENT_DATA".obs;
  var historyStatus = "SENDING_MODE".obs;
  var recordsTabMode = 0.obs;
  var itemSelected = {}.obs;
  var editToShareMode = "".obs;
  var subscription;
  String? userAgent;
  bool isPopup = false;
  var connectivityResult;

  late PageController pageController;
  RxInt currentPage = 0.obs;

  List<State> states = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController(initialPage: 0, keepPage: true);
  }

  void onChangeTab(int value) {
    try {
      currentPage.value = value;
      pageController.jumpToPage(value);
    } catch (e) {
      print(e);
      currentPage.value = value;
      pageController = PageController(initialPage: value, keepPage: true);
    }
  }

  Future getStates() async {
    try {
      var response;
      CustomDio customDio = CustomDio();

      response = await customDio.get("/contacts/states");
      var json = jsonDecode(response.toString());

      if (json["data"]["states"] != null) {
        List<dynamic> responseData = json["data"]["states"];

        List<State> res = [];

        for (int i = 0; i < responseData.length; i++) {
          State item = new State();
          item.id = responseData[i]["id"];
          item.name = responseData[i]["name"];
          res.add(item);
        }

        states.clear();
        states = res;
      }

      return (true);
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future getCategories() async {
    try {
      CustomDio customDio = CustomDio();
      var response = await customDio.get("/categories");
      var json = jsonDecode(response.toString());

      List<dynamic> responseData = json["data"]["result"];

      List<Category> res = [];

      for (int i = 0; i < responseData.length; i++) {
        Category item = Category();
        item.id = responseData[i]["id"];
        item.name = responseData[i]["name"];
        res.add(item);
      }

      categories.clear();
      categories.value = res;
      return (true);
    } catch (e) {
      print(e);
      return (false);
    }
  }
}
