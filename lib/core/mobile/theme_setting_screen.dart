import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/mobile/login/ui/login.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
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
    if (res != OPTION_CANCEL) {
      exit(0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: WHITE_COLOR,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              hightSpacer50,
              Image.asset(APP_ICON, width: 100, height: 100),
              hightSpacer50,
              instanceUrlTxtboxSection(context),
              hightSpacer20,
               errorTextBoxSection(context),
              hightSpacer32,
                continueBtnWidget(context),
                hightSpacer25
            ]),
          ),
        ),
      ),
    );
  }

  Widget instanceUrlTxtboxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
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
            hightSpacer50,
            InkWell(
              onTap: () {
                
                if (isValidInstanceUrl()  
                 ? pingPong(_urlCtrl.text,)
                 : 
                  ),
                
              },
              child: Container(
                width: 380,
                height: 50,
                decoration: BoxDecoration(
                  //  color: _urlCtrl.text.length == 10
                  //     ? MAIN_COLOR
                  //     : MAIN_COLOR.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: LARGE_FONT_SIZE,
                      color: MAIN_COLOR,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  bool isValidInstanceUrl() {
    String url = "https://${_urlCtrl.text}/api/";
    return Helper.isValidUrl(url);
  }


 Widget continueBtnWidget(context) => Center(
        child: ButtonWidget(
          onPressed: () async {
            await DbInstanceUrl().deleteUrl();
            String url = "https://${_urlCtrl.text}/api/";
            await pingPong(url);
          },
          title: LOGIN_TXT,
          colorBG: MAIN_COLOR,
          width: MediaQuery.of(context).size.width,
        ),
      );
  Future<void> pingPong(String url) async {
    const String apiUrl =
        'https://getpos.in/api/method/ping';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        
        log('API Response:');
        log(response.body);
        if (!mounted) return;
        Helper.hideLoader(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
     
        log('API Request failed with status code ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      log('Error: $e');
    }
  }
}
Widget errorTextBoxSection(context) => Center(
        child: Text(
            "Invalid Url",
            style: getTextStyle(
                fontSize: MEDIUM_PLUS_FONT_SIZE,
                fontWeight: FontWeight.w500,
                color: MAIN_COLOR),
          ),
        );
// Future<void> fetchData() async {
//   const String apiUrl = 'https://getpos.in/api/method/ping';
//     {
//       if (_urlCtrl.isEmpty) {
//         Helper.showPopup(context, "Please Enter URL");
//       }
//       else {
//         try {
//           Helper.showLoaderDialog(context);

//          final apiResponse = await http.get(Uri.parse(apiUrl));
//           log(apiResponse);

//           if (apiResponse.status!) {
//             //Adding static data into the database
//             // await addDataIntoDB();
//             if (!mounted) return;
//             Helper.hideLoader(context);
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => Login()));
//           } else {
//             if (!mounted) return;
//             Helper.hideLoader(context);
//             Helper.showPopup(context, apiResponse.message!);
//           }
//         } catch (e) {
//           Helper.hideLoader(context);
//           log('Exception Caught :: $e');
//           debugPrintStack();
//           Helper.showSnackBar(context, SOMETHING_WRONG);
//         }
//       }
//     }
//   }
//}
