import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/constants/asset_paths.dart';

import 'package:nb_posx/core/service/theme/api/theme_api_service.dart';
import 'package:nb_posx/core/tablet/login/login_landscape.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
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
   bool? isSSL = true;
   String prefix = "";
  @override
  void initState() {
    super.initState();

    _urlCtrl = TextEditingController();

    _urlCtrl.text = "getpos.in";
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
                          hightSpacer25,
                          useSSLCheckbox(context),
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

 //Input field for entering the instance URL
  Widget useSSLCheckbox(context) => Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: CheckboxListTile(
              //checkbox positioned at right
              value: isSSL,
              onChanged: (bool? value) {
                setState(() {
                  isSSL = value;
                });
              },
              activeColor: AppColors.primary,
              title: const Text("Use SSL"),
            ),
        ),
      );



  Widget continueButtonWidget(context) => Center(
        child: ButtonWidget(
          onPressed: () async {
            //to save the Url in DB
                  await DbInstanceUrl().saveUrl(_urlCtrl.text);
                  bool isInternetAvailable = await Helper.isNetworkAvailable();
                  String url = await DbInstanceUrl().getUrl();
                  //   String url = '${_urlCtrl.text}';

                  isSSL! ? prefix = "https" : prefix = "http";
                  var dbPreferences = DBPreferences();
                  await dbPreferences.savePreference(SSL_PREFIX, prefix);
                  // url = "https://${_urlCtrl.text}/api/";
                  if (isValidInstanceUrl(url) == true &&
                      isInternetAvailable == true) {
                    url = "$prefix://${_urlCtrl.text}/api/";

                    await pingPong(url);
                  }
                   else if (isValidIPv4(url)) {
                     String url = await DbInstanceUrl().getUrl();
                    var dbPreferences = DBPreferences();
                    await dbPreferences.savePreference(IP_ADDRESS, url);
                    await theme(url);
                  }
             else if (url.isEmpty) {
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
    if (url == "$prefix://${_urlCtrl.text}/api/") {
      return Helper.isValidUrl(url);
    } else {
      url = "$prefix://$url/api/";

      return Helper.isValidUrl(url);
    }
  }
   bool isValidIPv4(String ipAddress) {
    // Regular expression for IPv4 address
    final ipv4Regex = RegExp(r'^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
        r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
        r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
        r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$');

    return ipv4Regex.hasMatch(ipAddress);
  }


  Future<void> pingPong(String url) async {
    //  String apiUrl = 'https://${_urlCtrl.text}/api/method/ping';
    String apiUrl = '${url}method/ping';
    {
      try {
        final response = await http.get(Uri.parse(apiUrl));
        log('Api url for ping pong: $apiUrl');

        if (response.statusCode == 200) {
          log('API Response:');
          log(response.body);
          //not going inside the api
          await theme(url);
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
      }
    }
  }

  Future<void> theme(String url) async {
    try {
      Helper.showLoaderDialog(context);
      //api theme path get and append

      String apiUrl = THEME_PATH;
      CommanResponse response = await ThemeService.fetchTheme(apiUrl);
      log('$response');

      if (response.status != null && response.status!) {
        // ignore: use_build_context_synchronously
        Helper.hideLoader(context);

        log('url:$url');
        // ignore: use_build_context_synchronously
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginLandscape(
                      isUserLoggedIn: true,
                    )));
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showPopup(context, response.message);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Helper.hideLoader(context);
      log('Exception Caught :: $e');

      debugPrintStack();
      // ignore: use_build_context_synchronously
      Helper.showSnackBar(context, SOMETHING_WRONG);
    }
  }
}
