import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/my_request/my_request_user_controller.dart';
import 'package:untitled/utils/config.dart';
import 'package:untitled/widgets/bounce_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:untitled/widgets/input.dart';

Future cancelRequestPopup() {
  return Get.defaultDialog(
    titlePadding: EdgeInsets.all(0),
    contentPadding: EdgeInsets.only(
      top: getHeight(32),
      left: getWidth(16),
      right: getWidth(16),
      bottom: getHeight(16),
    ),
    titleStyle: TextStyle(fontSize: 0),
    radius: 8,
    content: Container(
      width: 352,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/icons/cancel_request.png"),
          SizedBox(
            height: getHeight(20),
          ),
          Text(
            "Are you sure you want to cancel request?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: getHeight(20),
          ),
          Bouncing(
            child: Container(
              alignment: Alignment.center,
              height: getHeight(48),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Yes I do",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onPress: () => Get.back(),
          ),
          SizedBox(
            height: getHeight(8),
          ),
          Bouncing(
            child: Container(
              alignment: Alignment.center,
              height: getHeight(48),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFF0000),
                    width: getWidth(1),
                  )),
              child: Text(
                "No, keep service",
                style: TextStyle(
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
            onPress: () => Get.back(),
          ),
        ],
      ),
    ),
  );
}

Future feedbackPopup(
    {required BuildContext context, String? title, String? service}) {
  return Get.defaultDialog(
    titlePadding: EdgeInsets.only(
      top: getHeight(20),
    ),
    contentPadding: EdgeInsets.only(
      top: getHeight(20),
      left: getWidth(16),
      right: getWidth(16),
    ),
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    radius: 8,
    title: "Local clean feedback",
    content: Container(
      width: getWidth(352),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RatingBar(
            allowHalfRating: true,
            itemCount: 5,
            ratingWidget: RatingWidget(
                half: Icon(Icons.star_half),
                full: Icon(Icons.star),
                empty: Icon(Icons.star_outline)),
            onRatingUpdate: (double value) {},
            itemSize: 30,
          ),
          SizedBox(
            height: getHeight(10),
          ),
          Text(
            "rating from 1 to 5",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(
            height: getHeight(24),
          ),
          Text(
            "Service: $service",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(
            height: getHeight(12),
          ),
          inputRegular(
            context,
            hintText: "Share your experience",
            textEditingController: Get.put(MyRequestUserController()).feedback,
            height: getHeight(117),
            maxLines: 6,
            minLines: 6,
          ),
          SizedBox(
            height: getHeight(12),
          ),
          Bouncing(
            child: Container(
              alignment: Alignment.center,
              height: getHeight(48),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Send feedback",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onPress: () => Get.back(),
          ),
          SizedBox(
            height: getHeight(8),
          ),
          Bouncing(
            child: Container(
              alignment: Alignment.center,
              height: getHeight(48),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFFF0000),
                    width: getWidth(1),
                  )),
              child: Text(
                "Close",
                style: TextStyle(
                  color: Color (0xFFFF0000),
                ),
              ),
            ),
            onPress: () => Get.back(),
          ),
        ],
      ),
    ),
  );
}
