import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:untitled/controller/account/account_controller.dart';
import 'package:untitled/main.dart';
import 'package:untitled/screen/handyman/service_area/service_area_screen.dart';
import 'package:untitled/utils/config.dart';
import 'package:untitled/widgets/app_bar.dart';
import 'package:untitled/widgets/bounce_button.dart';
import 'package:untitled/widgets/dialog.dart';
import 'package:untitled/widgets/dropdown.dart';
import 'package:untitled/widgets/image.dart';
import 'package:untitled/widgets/input.dart';
import 'package:us_states/us_states.dart';
import 'package:image_picker/image_picker.dart';

class BusinessManagementScreen extends StatefulWidget {
  @override
  State<BusinessManagementScreen> createState() => _BusinessManagementScreenState();
}

class _BusinessManagementScreenState extends State<BusinessManagementScreen> {
  File logoFile = File("");
  File bannerFile = File("");

  @override
  Widget build(BuildContext context) {
    AccountController accountController = Get.put(AccountController());
    accountController.getBusinessInfo();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(
          title: "Manage business",
          backFunction: () {
            accountController.isEditting.value = false;
          },
          actions: [
            GestureDetector(
              onTap: () async {
                if (accountController.isEditting.value) {
                  if (accountController.isBusinessScreen.value) {
                    if (accountController.business.text == "" || accountController.tags.isEmpty) {
                      CustomDialog(context, "FAILED").show({"message": "missing_field"});
                      return;
                    }
                    accountController.isLoading.value = true;
                    if (logoFile.path != "") {
                      var contentLength = await logoFile.length();
                      var filename = logoFile.path.split("/").last;
                      var logoUrl = await ImageService.handleUploadImage(filename, contentLength, logoFile);
                      accountController.logoImage.value = logoUrl;
                    }
                    if (bannerFile.path != "") {
                      var contentLength = await bannerFile.length();
                      var filename = bannerFile.path.split("/").last;
                      var bannerUrl = await ImageService.handleUploadImage(filename, contentLength, bannerFile);
                      accountController.bannerImage.value = bannerUrl;
                    }

                    var result = await accountController.editBusinessInfo();
                    if (result != null) {
                      accountController.isBusinessScreen.value = false;
                    }
                  } else {
                    if (accountController.phoneNumber.text == "" || accountController.city.text == "" || accountController.address1.text == "" || accountController.zipcode.text == "") {
                      CustomDialog(context, "FAILED").show({"message": "missing_field"});
                      return;
                    }
                    var result = await accountController.editBusinessContact();
                    if (result != null) {
                      accountController.isBusinessScreen.value = false;
                      Get.to(() => ServiceAreaScreen());
                    }
                  }
                }
                accountController.isLoading.value = false;
                accountController.isEditting.value = !accountController.isEditting.value;
              },
              child: Obx(
                    () => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: getHeight(16)),
                    child: Text(
                      accountController.isEditting.value ? "Update" : "Edit",
                      style: TextStyle(color: const Color(0xFF3864FF), fontSize: getHeight(14), decoration: TextDecoration.underline),
                    )),
              ),
            ),
          ]),
      body: Container(
        padding: EdgeInsets.only(
          left: getWidth(27),
          right: getWidth(27),
          bottom: getHeight(32),
        ),
        child: ListView(
          children: [
            Row(
              children: [
                Bouncing(
                  child: Obx(() {
                    return Container(
                      height: getHeight(36),
                      width: getWidth(97),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        color: accountController.isBusinessScreen.value ? Color(0xFFC4C4C4) : Color(0xFFFFFFFF),
                      ),
                      child: const Text("Service info"),
                    );
                  }),
                  onPress: () {
                    if (!accountController.isBusinessScreen.value) {
                      accountController.isEditting.value = false;
                      accountController.isBusinessScreen.value = true;
                    }
                  },
                ),
                SizedBox(
                  width: getWidth(11),
                ),
                Bouncing(
                  child: Obx(() {
                    return Container(
                      height: getHeight(36),
                      width: getWidth(97),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: accountController.isBusinessScreen.value ? Color(0xFFFFFFFF) : Color(0xFFC4C4C4)),
                      child: Text("Contact info"),
                    );
                  }),
                  onPress: () {
                    if (accountController.isBusinessScreen.value) {
                      accountController.isEditting.value = false;
                      accountController.isBusinessScreen.value = false;
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: getHeight(15),
            ),
            Obx(
              () => accountController.isBusinessScreen.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getHeight(20),
                        ),
                        Text(
                          "Logo images",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getHeight(18),
                          ),
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        Text(
                          "This image will also be used for navigation. ",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: getHeight(12), color: const Color(0xFF696969)),
                        ),
                        Text(
                          "At least 210x210 recommended. ",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: getHeight(12), color: const Color(0xFF696969)),
                        ),
                        SizedBox(
                          height: getHeight(10),
                        ),
                        logoFile.path == "" && accountController.logoImage.value == ""
                            ? GestureDetector(
                                onTap: () async {
                                  if (!accountController.isEditting.value) {
                                    return;
                                  }
                                  XFile? pickedFile = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                    maxWidth: 1800,
                                    maxHeight: 1800,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      logoFile = File(pickedFile.path);
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                ),
                              )
                            : Obx(() => GestureDetector(
                                  onTap: () async {
                                    if (!accountController.isEditting.value) {
                                      return;
                                    }
                                    XFile? pickedFile = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                      maxWidth: 1800,
                                      maxHeight: 1800,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        logoFile = File(pickedFile.path);
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(56),
                                      child: Container(
                                          width: getHeight(60),
                                          height: getHeight(60),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: accountController.logoImage.value != "" ? Colors.blueGrey : Colors.transparent),
                                          child: logoFile.path != ""
                                              ? Image.file(
                                                  logoFile,
                                                  fit: BoxFit.cover,
                                                )
                                              : getImage(accountController.logoImage.value, width: getWidth(60), height: getHeight(60))),
                                    ),
                                  ),
                                )),
                        SizedBox(
                          height: getHeight(18),
                        ),
                        Text(
                          "Banner",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: getHeight(18),
                          ),
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        Text(
                          "This image will also be used for navigation. ",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: getHeight(12), color: const Color(0xFF696969)),
                        ),
                        Text(
                          "Recommend size 1000x55",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: getHeight(12), color: const Color(0xFF696969)),
                        ),
                        SizedBox(
                          height: getHeight(10),
                        ),
                        bannerFile.path == "" && accountController.bannerImage.value == ""
                            ? GestureDetector(
                                onTap: () async {
                                  if (!accountController.isEditting.value) {
                                    return;
                                  }
                                  XFile? pickedFile = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                    maxWidth: 1800,
                                    maxHeight: 1800,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      bannerFile = File(pickedFile.path);
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                ),
                              )
                            : Obx(() => GestureDetector(
                                  onTap: () async {
                                    if (!accountController.isEditting.value) {
                                      return;
                                    }
                                    XFile? pickedFile = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                      maxWidth: 1800,
                                      maxHeight: 1800,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        bannerFile = File(pickedFile.path);
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        height: getWidth(56),
                                        width: getWidth(108),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(color: accountController.logoImage.value != "" ? Colors.blueGrey : Colors.transparent),
                                        ),
                                        child: bannerFile.path != ""
                                            ? Image.file(
                                                bannerFile,
                                                fit: BoxFit.cover,
                                              )
                                            : getImage(accountController.bannerImage.value)),
                                  ),
                                )),
                        SizedBox(
                          height: getHeight(18),
                        ),
                        inputRegular(
                          context,
                          label: "Business name",
                          hintText: "",
                          textEditingController: accountController.business,
                          enabled: accountController.isEditting.value,
                          required: true,
                        ),
                        SizedBox(
                          height: getHeight(18),
                        ),
                        Obx(
                          () => accountController.isEditting.value
                              ? MultiSelectDialogField(
                                  title: const Text("Category"),
                                  items: globalController.categories.map((e) => MultiSelectItem(e, e.name)).toList(),
                                  listType: MultiSelectListType.CHIP,
                                  onConfirm: (values) {
                                    accountController.tags.value = values;
                                  },
                                  buttonText: Text(
                                    "Professional Category*",
                                    style: TextStyle(fontSize: getHeight(14), color: accountController.isEditting.value ? Colors.black : const Color(0xFF999999)),
                                  ),
                                )
                              : inputRegular(
                                  context,
                                  hintText: "Professional Category*",
                                  textEditingController: accountController.category,
                                  enabled: accountController.isEditting.value,
                                ),
                        ),
                        SizedBox(
                          height: getHeight(18),
                        ),
                        inputRegular(context,
                            label: "Description",
                            hintText: "",
                            enabled: accountController.isEditting.value,
                            textEditingController: accountController.description,
                            maxLines: 6,
                            keyboardType: TextInputType.multiline,
                            height: 120,
                            minLines: 4),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputRegular(
                          context,
                          label: "Phone number",
                          hintText: "",
                          required: true,
                          textEditingController: accountController.phoneNumber,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        Stack(children: [
                          inputRegular(
                            context,
                            label: "State",
                            hintText: "",
                            enabled: accountController.isEditting.value,
                            textEditingController: accountController.state,
                            height: 54,
                            required: true,
                          ),
                          Obx(() => accountController.isEditting.value
                              ? getDropDown(
                                  USStates.getAllNames(),
                                  (String value) => {accountController.state.text = value},
                                )
                              : Container()),
                        ]),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          label: "City*",
                          hintText: "",
                          required: true,
                          textEditingController: accountController.city,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          label: "Country",
                          hintText: "",
                          textEditingController: accountController.country,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          label: "Address 1",
                          hintText: "",
                          required: true,
                          textEditingController: accountController.address1,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          hintText: "Address 2",
                          textEditingController: accountController.address2,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          label: "Zipcode",
                          hintText: "",
                          required: true,
                          textEditingController: accountController.zipcode,
                          enabled: accountController.isEditting.value,
                        ),
                        SizedBox(
                          height: getHeight(8),
                        ),
                        inputRegular(
                          context,
                          hintText: "Website",
                          textEditingController: accountController.website,
                          enabled: accountController.isEditting.value,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
