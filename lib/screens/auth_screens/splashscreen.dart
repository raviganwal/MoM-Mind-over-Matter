import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mom/screens/auth_screens/get_started_screen.dart';
import 'package:mom/screens/main_screens/nav_screen.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/ui_widgets/loading_screen.dart';

// void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = Hive.box(hCommonBox);

  @override
  void initState() {
    super.initState();
    splashFunction();
  }

  splashFunction() async {
    await box.put(hIsNotify, true);
    await Future.delayed(const Duration(seconds: 3), () {
      firebaseAuth.currentUser != null ? Get.offAll(() => NavScreen()) : Get.offAll(() => GetStartedScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingScreen(),
    );
  }
}
