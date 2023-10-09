import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/mobile/login/ui/login.dart';
import 'package:nb_posx/core/mobile/splash/view/splash_screen.dart';
import 'package:nb_posx/core/service/theme/api/model/theme_response.dart';
import 'package:nb_posx/core/service/theme/api/theme_api_service.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/utils/ui_utils/textfield_border_decoration.dart';
import 'package:nb_posx/widgets/button.dart';
import 'package:nb_posx/widgets/text_field_widget.dart';

class ThemeChangeTablet extends StatefulWidget {
  const ThemeChangeTablet({Key? key}) : super(key: key);

  @override
  State<ThemeChangeTablet> createState() => _ThemeChangeTabletState();
}

class _ThemeChangeTabletState extends State<ThemeChangeTablet> {
  late TextEditingController _urlCtrl;
  late BuildContext ctx;
  String? version;
  AppColors appColors = AppColors();
  @override
  void initState() {
    super.initState();

    _urlCtrl = TextEditingController();

    _urlCtrl.text = instanceUrl;
   
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);
    if (res == OPTION_YES) {
      exit(0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ctx = context;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.fontWhiteColor,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: 550,
                    padding: paddingXY(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //hightSpacer75,

                          headingLblWidget(),

                          hightSpacer50,
                          subHeadingLblWidget(),
                          hightSpacer25,
                          instanceUrlTxtboxSection(context),
                          hightSpacer50,
                          continueButtonWidget(_urlCtrl.text),
                          hightSpacer20,
                        ])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headingLblWidget() => Center(
        // child: Text(
        //   "POS",
        //   style: getTextStyle(
        //     color: MAIN_COLOR,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 72.0,
        //   ),
        // ),
        child: Image.asset(
          App_ICON,
          height: 150,
          width: 150,
        ),
      );

  Widget subHeadingLblWidget() => Center(
        child: Text(
          URL_TXT,
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: LARGE_FONT_SIZE,
          ),
        ),
      );
  //Input field for entering the instance URL
  Widget instanceUrlTxtboxSection(context) => Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _urlCtrl,
            verticalContentPadding: 16,
            hintText: URL_HINT,
          ),
        ),
      );

  Widget continueButtonWidget(context) => Center(
        child: ButtonWidget(
          onPressed: () async {
            //to save the Url in DB
            await DbInstanceUrl().saveUrl(_urlCtrl.text);
          
//to save the url in a string
            String url = "https://${_urlCtrl.text}/api/";
            if (isValidInstanceUrl(url) == true) {
              pingPong(_urlCtrl.text);
              // theme(url, context);
            } else if (url.isEmpty) {
              Helper.showPopup(context, "Please Enter Url");
            } else {
              Helper.showPopup(context, invalidErrorText);
            }
          },
          title: CONTINUE_TXT,
          primaryColor: AppColors.getPrimary(),
          height: 60,
          fontSize: LARGE_PLUS_FONT_SIZE,
          // width: MediaQuery.of(context).size.width,
        ),
      );

  bool isValidInstanceUrl(String url) {
    //String url = "https://${_urlCtrl.text}/api/";
    return Helper.isValidUrl(url);
  }

  Future<void> pingPong(String url) async {
    String apiUrl = 'https://${_urlCtrl.text}/api/method/ping';

    {
      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          log('API Response:');
          log(response.body);
          

          if (!mounted) return;
          Helper.hideLoader(context);
          
        } else {
          

          log('API Request failed with status code ${response.statusCode}');
          log('Response body: ${response.body}');
          log('Dbinstance Url:');
        }
      } catch (e) {
        // Handle any exceptions during the request

        log('Error: $e');
        Helper.showPopup(context, "Not an active Url");
        // Helper.hideLoader(context);
      }
    }
  }

  Future<void> theme(String url, BuildContext context) async {
    try {
      Helper.showLoaderDialog(context);
      //api theme path get and append
      //  String apiUrl = "$BASE_URL$THEME_PATH";
      String apiUrl = "https://$url/api/$THEME_PATH";
      CommanResponse response = await ThemeService.fetchTheme(apiUrl);
      log('$response');

      if (response.status!) {
        //Adding static data into the database
        // await addDataIntoDB();
        log('$response');
        //if (!mounted) return;
        Helper.hideLoader(context);
        log('$context');
        (() => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login())));
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showPopup(context, response.message!);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const Login()));
      }
    } catch (e) {
      Helper.hideLoader(context);
      log('Exception Caught :: $e');
      debugPrintStack();
      Helper.showSnackBar(context, SOMETHING_WRONG);
    }
  }
}
