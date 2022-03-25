import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/global_controller.dart';
import 'package:untitled/model/custom_dio.dart';

class MyRequestUserController extends GetxController {
  RxList<dynamic> pendingRequests = [].obs;
  RxList<dynamic> connectedRequests = [].obs;
  RxList<dynamic> completedRequests = [].obs;

  TextEditingController feedback = TextEditingController();

  Future getRequests(String serviceId) async {
    try {
      var response;
      CustomDio customDio = CustomDio();
      customDio.dio.options.headers["Authorization"] =
          Get.put(GlobalController()).user.value.certificate.toString();
      pendingRequests.clear();
      connectedRequests.clear();
      completedRequests.clear();

      response = await customDio.get("/orders?status=0&serviceId=$serviceId");
      print(response);

      var json = jsonDecode(response.toString());
      if (json["data"]["result"] != null) {
        pendingRequests.value = json["data"]["result"];
      }

      response = await customDio.get("/orders?status=1&serviceId=$serviceId");
      print(response);
      json = jsonDecode(response.toString());
      if (json["data"]["result"] != null) {
        connectedRequests.value = json["data"]["result"];
      }

      response = await customDio.get("/orders?status=4&serviceId=$serviceId");
      print(response);
      json = jsonDecode(response.toString());
      if (json["data"]["result"] != null) {
        completedRequests.value = json["data"]["result"];
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendFeedback(
    String orderId,
    double rate,
    String serviceId,
    String businessId,
  ) async {
    try {
      var response;
      CustomDio customDio = CustomDio();
      customDio.dio.options.headers["Authorization"] =
          Get.put(GlobalController()).user.value.certificate.toString();

      response = await customDio.post(
        "/feedbacks",
        {
          "data": {
            "orderId": orderId,
            "rate": rate,
            "comment": feedback.text,
            "serviceId": serviceId,
            "businessId": businessId,
          },
        },
      );

      var json = jsonDecode(response.toString());
      return json["success"];
    } catch (e) {
      print(e);
      return false;
    }
  }
}
