import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
import 'package:nb_posx/core/tablet/login/login_landscape.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_customer.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
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

class ThemeChange extends StatefulWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  State<ThemeChange> createState() => _ThemeChangeState();
}

class _ThemeChangeState extends State<ThemeChange> {
  late TextEditingController _urlCtrl;
  String? version;
  AppColors appColors = AppColors();
  bool isInternetAvailable = false;
  String prefix = "";
  bool? isSSL = true;
  RegExp? ipExp;
  @override
  void initState() {
    super.initState();

    _urlCtrl = TextEditingController();

    _urlCtrl.text = "getpos.in";

    //updateColorsFromThemeResponse(appColors);
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
    return Center(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.fontWhiteColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //hightSpacer75,
                        Image.asset(App_ICON, width: 100, height: 100),
                        hightSpacer50,

                        instanceUrlTxtboxSection(context),
                        hightSpacer120,
                      ])),
            ),
          ),
        ),
      ),
    );
  }

  Widget instanceUrlTxtboxSection(context) => Container(
        margin: horizontalSpace(),

        // padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 20),
              child: Text(
                URL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _urlCtrl,
              hintText: URL_HINT,
            ),
            hightSpacer20,
            CheckboxListTile(
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
            hightSpacer100,
            Center(
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
                  //                 else if
                  //                    (RegExp(r'^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
                  //         r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
                  //         r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.'
                  //         r'(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$').hasMatch(Uri.parse(url).host)) {
                  //   await theme(url);
                  // }

// else if(RegExp(
//       r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$").hasMatch(Uri.parse(url).host)) {
//  await theme(url);
// }

                  else if (isValidIPv4(url)) {
                     String url = await DbInstanceUrl().getUrl();
                    // var dbPreferences = DBPreferences();
                    // await dbPreferences.savePreference(IP_ADDRESS, url);
                    await theme(url);
                  }
                  // RegExp ipExp = RegExp(
                  //     r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$",
                  //     caseSensitive: false,
                  //     multiLine: false);

                  else if (url.isEmpty) {
                    Helper.showPopup(context, "Please Enter Url");
                  } else {
                    Helper.showPopup(context, invalidErrorText);
                  }
                },
                title: CONTINUE_TXT,
                // primaryColor: const Color(0xFFDC1E44),
                primaryColor: AppColors.getPrimary(),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      );

  bool isValidInstanceUrl(String url) {
    //String url = "https://${_urlCtrl.text}/api/";
    if (url == "$prefix://${_urlCtrl.text}/api/") {
      return Helper.isValidUrl(url);
    }
    //  else if
    //                  (RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$').hasMatch(Uri.parse(url).host)){
    //      return Helper.isValidUrl(url);
    //                  }
    else {
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
                builder: (context) => const Login(
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
