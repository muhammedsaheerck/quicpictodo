// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quicpictodo/core/router.dart';

import '../../core/app_constants.dart';
import '../../core/extentions.dart';
import '../widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    changeScreen(context);
  }

  bool checkingButton = false;
  Future<void> changeScreen(BuildContext context) async {
    final check = await checking();
    await Future.delayed(
      const Duration(seconds: 4),
    );
    context.goNamed(AppRouter.homeScreen);
  }

  Future<bool> checking() async {
    checkingButton = true;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checkingButton = false;
        return true;
      }
      checkingButton = false;
      return false;
    } on SocketException catch (_) {
      checkingButton = false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.mainColor,
      body: SizedBox(
        height: Responsive.hp(100),
        width: Responsive.wp(100),
        child: const Center(
          child: CommonTextWidget(
              text: "Quicpictodo",
              fontSize: 40,
              color: AppConstants.whiteColor,
              height: 56),
        ),
      ),
    );
  }
}
