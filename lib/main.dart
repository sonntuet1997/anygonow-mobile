import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:untitled/controller/global_controller.dart';
import 'package:untitled/i18n.dart';
import 'package:untitled/screen/login/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

GlobalController globalController = Get.put(GlobalController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51KQyIYHKYRxtUDcpc8lKY260HdU59NP0SkXg4zOu18S4lbLAH3uREkrR9KNpUp5HICQwZm3utRrwOHTVbQknue3A00jFmfMeSj";
  await dotenv.load(fileName: ".env");
  await globalController.getStates();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('en')],
      translations: Messages(),
      locale: const Locale('en', 'US'),
      defaultTransition:
          Platform.isIOS ? Transition.cupertino : Transition.rightToLeft,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "TTNorm-Bold"),
      home: home(),
    );
  }

  Widget home() {
    return LoginScreen();
  }
}
