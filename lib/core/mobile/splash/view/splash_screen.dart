import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_posx/core/mobile/login/ui/login.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../main.dart';
import '../../home/ui/product_list_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        (() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => isUserLoggedIn
                    ? const ProductListHome()
                    : const Login()))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MAIN_COLOR,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Stack(
            children: [
              Center(
                  child: Image.asset(
                APP_ICON,
                width: 200,
                height: 200,
              )),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        POWERED_BY_TXT,
                        style: getTextStyle(color: WHITE_COLOR, fontSize: 16.0),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
