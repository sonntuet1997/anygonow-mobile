import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/handyman/my_request/my_request_controller.dart';
import 'package:untitled/service/date_format.dart';
import 'package:untitled/utils/config.dart';
import 'package:untitled/widgets/bounce_button.dart';
import 'package:untitled/widgets/image.dart';

class MyRequestScreen extends StatelessWidget {
  MyRequestController myRequestController = Get.put(MyRequestController());

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
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: getHeight(16),
              left: getWidth(16),
              right: getWidth(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Number of free customer information view: ${myRequestController.requests.length}",
                  style: TextStyle(
                    fontSize: getHeight(12),
                    color: const Color(0xFF999999),
                  ),
                ),
                Bouncing(
                  onPress: () {},
                  child: const Text(
                    "Connect all",
                    style: TextStyle(
                      color: Color(0xFF3864FF),
                      decoration: TextDecoration.underline,
                      decorationThickness:2,
                      decorationColor: Color(0xFF3864FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: getWidth(20),
            right: getWidth(20),
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: getHeight(19),
              ),
              getRequests(),
            ],
          ),
        ),
      ),
    );
  }

  Column getRequests() {
    return Column(
      children: List.generate(
          myRequestController.requests.length,
          (index) => requestItem(
                startDate: TimeService.dateTimeToString2(
                    TimeService.stringToDateTime(
                            myRequestController.requests[index]["startDate"]) ??
                        DateTime(1, 1, 1)),
                endDate: TimeService.dateTimeToString2(
                    TimeService.stringToDateTime(
                            myRequestController.requests[index]["endDate"]) ??
                        DateTime(1, 1, 1)),
                serviceName:
                    myRequestController.requests[index]["serviceName"] ?? "",
                zipCode: myRequestController.requests[index]
                        ["customerZipcode"] ??
                    "",
                fee: myRequestController.requests[index]["fee"]?.toString() ??
                    "0",
                banner:
                    myRequestController.requests[index]["businessLogo"] ?? "",
              )),
    );
  }

  Container requestItem({
    String startDate = "",
    String endDate = "",
    String serviceName = "",
    String zipCode = "",
    String fee = "",
    String banner = "",
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: getHeight(13),
      ),
      height: getHeight(184),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Color(0xFFE6E6E6),
        ),
      ),
      padding: EdgeInsets.only(
        left: getWidth(13),
        top: getHeight(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: getHeight(118),
            width: getWidth(96),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: banner == "" ? SizedBox() : getImage(banner),
          ),
          SizedBox(
            width: getWidth(14),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Request time: $startDate",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(12),
                ),
              ),
              SizedBox(
                height: getHeight(8),
              ),
              Text(
                "Expiry time: $endDate",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(12),
                ),
              ),
              SizedBox(
                height: getHeight(8),
              ),
              Text(
                "Service requested: $serviceName",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getWidth(12),
                ),
              ),
              SizedBox(
                height: getHeight(8),
              ),
              Text(
                "Zip code: $zipCode",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getWidth(12),
                ),
              ),
              SizedBox(
                height: getHeight(8),
              ),
              Text(
                "Deal fee: \$$fee",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getWidth(12),
                ),
              ),
              SizedBox(
                height: getHeight(16),
              ),
              Row(
                children: [
                  Bouncing(
                    onPress: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: getHeight(32),
                      width: getWidth(81),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Text(
                        "Ignore",
                        style: TextStyle(
                          color: Color(0xFFFF511A),
                          fontSize: getWidth(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getWidth(7),
                  ),
                  Bouncing(
                    onPress: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: getHeight(32),
                      width: getWidth(115),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFFF511A),
                      ),
                      child: Text(
                        "View detail",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getWidth(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
