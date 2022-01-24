import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/api/certificate_service.dart';
import 'package:untitled/api/signature_service.dart';
import 'package:untitled/model/User.dart';
import 'package:untitled/model/custom_dio.dart';
import 'package:untitled/model/status.dart';
import 'package:untitled/screen/login/login_screen.dart';
import 'package:untitled/service/response_validator.dart';

import '../global_controller.dart';

class LoginPageController extends GetxController {
  Rx<LoginOption> loginOption = LoginOption.customer.obs;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future getPing(List<String> certificateList) async {
    try {
      CustomDio customDio = new CustomDio();
      // var certificateJson = jsonEncode(certificateList);
      print("cert: " + certificateList.toString());
      customDio.dio.options.headers["authorization"] = certificateList[0];

      var response = await customDio.post(
        "/auth/ping",
        certificateList[1],
        sign: false,
      );
      return response;
    } catch (e, s) {
      return null;
    }
  }

  Future getCredential(String username) async {
    try {
      var response;
      CustomDio customDio = CustomDio();
      response = await customDio.post(
          "/auth/credential",
          {
            "data": {
              "identifier": username.toString(),
            }
          },
          sign: false);
      return response;
    } catch (e, s) {
      return null;
    }
  }

  Future<bool> login() async {
    User userInfo = User();
    if (username.text == "") {
      print("Username can not be empty");
    } else if (password.text == "") {
      print("Password can not be empty");
    } else {
      var responseCredential = await getCredential(username.text);
      Status validateUsername = ResponseValidator.check(responseCredential);
      if (validateUsername.status == "OK") {
        print({"data": responseCredential});
        var data = responseCredential.data["data"];
        var userId = data["id"];
        var publicKey = data['publicKey'];
        var encryptedPrivateKey = data['encryptedPrivateKey'];
        var userName = username.text;
        String? privateKey =
        decryptAESCryptoJS(encryptedPrivateKey, password.text);

        print("pK:" + privateKey.toString());
        Status validatePassword = new Status();

        if (privateKey == null)
          validatePassword =
          new Status(status: "ERROR", message: "WRONG.PASSWORD");
        else
          validatePassword = new Status(status: "SUCCESS", message: "SUCCESS");

        if (validatePassword.status == "SUCCESS") {
          var certificateInfo = SignatureService.getCertificateInfo(userId);
          String signature = SignatureService.getSignature(
              certificateInfo, privateKey as String);
          int times = DateTime.now().toUtc().millisecondsSinceEpoch;
          List<String> certificateList = SignatureService.getCertificateLogin(
              certificateInfo,
              userId,
              privateKey,
              encryptedPrivateKey,
              signature,
              publicKey,
              times);

          var responsePing = await getPing(certificateList);
          print({"resPing": responsePing.toString()});
          Status validateServer2 = ResponseValidator.check(responsePing);
          if (validateServer2.status == "OK") {
            userInfo.id = userId;
            userInfo.name = userName;
            userInfo.phone = data["phone"];
            userInfo.publicKey = publicKey;
            userInfo.privateKey = privateKey;
            userInfo.encryptedPrivateKey = encryptedPrivateKey;
            userInfo.username = username.text;
            userInfo.certificate = certificateList[0];
            responsePing.data["data"]["blockchainIndex"];
            // Get.put(GlobalController()).db.put("user", userInfo);
            Get.put(GlobalController()).user.value = userInfo;
            return true;
          } else {
            print("Wrong password");
          }
        } else {
          print("Wrong password");
        }
      } else if (validateUsername.status == "ERROR.SERVER") {
        print("Error Server");
      } else {
        print("Username Invalid");
      }
    }
    return false;
  }
}
