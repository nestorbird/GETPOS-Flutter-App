import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/mobile/login/ui/login.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
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
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  String? version;

  @override
  void initState() {
    super.initState();

    _urlCtrl = TextEditingController();

    _urlCtrl.text = instanceUrl;

    //api call
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
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
    return Center(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: WHITE_COLOR,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //hightSpacer75,
                        Image.asset(APP_ICON, width: 100, height: 100),
                        hightSpacer100,

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
              padding: leftSpace(x: 10),
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
            hightSpacer100,
            Center(
              child: ButtonWidget(
                onPressed: () async {
                  //to save the Url in DB
                  await DbInstanceUrl().saveUrl(_urlCtrl.text);
// to Show loader after saving Url in DB
                  Helper.showLoaderDialog(context);

                  String url = "https://${_urlCtrl.text}/api/";
                  if (isValidInstanceUrl(url) == true) {
                    pingPong(_urlCtrl.text);
                  } else {
                    Helper.showPopup(context, invalidErrorText);
                  }
                },
                title: CONTINUE_TXT,
                colorBG: MAIN_COLOR,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
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
          Helper.showPopup(context, "Please Enter URL");

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          // ignore: use_build_context_synchronously
          //

          log('API Request failed with status code ${response.statusCode}');
          log('Response body: ${response.body}');
          log('Dbinstance Url:');
        }
      } catch (e) {
        // Handle any exceptions during the request
        Helper.showPopup(context, notAnActiveUrl);
        log('Error: $e');
      }
    }
  }
}
