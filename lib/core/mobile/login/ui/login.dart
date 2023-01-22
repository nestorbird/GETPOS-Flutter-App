import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_posx/core/mobile/home/ui/product_list_home.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../constants/asset_paths.dart';
import '../../../service/login/api/login_api_service.dart';
import '../../forgot_password/ui/forgot_password.dart';
import '../../webview_screens/enums/topic_types.dart';
import '../../webview_screens/ui/webview_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  String? version;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _emailCtrl.text = "";
    _passCtrl.text = "";
    _urlCtrl.text = instanceUrl;

    _getAppVersion();
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: WHITE_COLOR,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                hightSpacer50,
                hightSpacer50,
                hightSpacer15,
                Image.asset(APP_ICON, width: 100, height: 100),
                hightSpacer50,
                instanceUrlTxtboxSection(context),
                hightSpacer50,
                headingLblWidget(context),
                hightSpacer5,
                subHeadingLblWidget(context),
                hightSpacer15,
                emailTxtboxSection(context),
                hightSpacer10,
                passwordTxtboxSection(context),
                hightSpacer10,
                forgotPasswordSection(context),
                hightSpacer50,
                hightSpacer32,
                termAndPolicySection(context),
                hightSpacer32,
                loginBtnWidget(context),
                hightSpacer25
                // const Spacer(),
                // Center(
                //     child: Text(
                //   version ?? APP_VERSION_FALLBACK,
                //   style: getHintStyle(),
                // )),
                // hightSpacer10
              ],
            )),
      ),
    );
  }

  /// HANDLE LOGIN BTN ACTION
  Future<void> login(String email, String password, String url) async {
    try {
      Helper.showLoaderDialog(context);

      CommanResponse response = await LoginService.login(email, password, url);

      if (response.status!) {
        //Adding static data into the database
        // await addDataIntoDB();
        if (!mounted) return;
        Helper.hideLoader(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProductListHome()));
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showPopup(context, response.message!);
      }
    } catch (e) {
      Helper.hideLoader(context);
      log('Exception Caught :: $e');
      debugPrintStack();
      Helper.showSnackBar(context, SOMETHING_WRONG);
    }
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "$APP_VERSION - ${packageInfo.version}";
    });
  }

  ///Input field for entering the instance URL
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
          ],
        ),
      );

  /// LOGIN BUTTON
  Widget loginBtnWidget(context) => Center(
        child: ButtonWidget(
          onPressed: () async {
            await DbInstanceUrl().deleteUrl();
            String url = "https://${_urlCtrl.text}/api/";
            await login(_emailCtrl.text, _passCtrl.text, url);
          },
          title: LOGIN_TXT,
          colorBG: MAIN_COLOR,
          width: MediaQuery.of(context).size.width - 100,
        ),
      );

  /// EMAIL SECTION
  Widget emailTxtboxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                EMAIL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _emailCtrl,
              hintText: EMAIL_HINT,
            ),
          ],
        ),
      );

  /// PASSWORD SECTION
  Widget passwordTxtboxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                PASSWORD_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _passCtrl,
              hintText: PASSWORD_HINT,
              password: true,
            ),
          ],
        ),
      );

  /// FORGOT PASSWORD SECTION
  Widget forgotPasswordSection(context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                FORGET_PASSWORD_SMALL_TXT,
                style: getTextStyle(
                    color: MAIN_COLOR,
                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      );

  /// TERM AND CONDITION SECTION
  Widget termAndPolicySection(context) => Padding(
        padding: horizontalSpace(x: 40),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: BY_SIGNING_IN,
              style: getTextStyle(
                  color: DARK_GREY_COLOR,
                  fontSize: MEDIUM_FONT_SIZE,
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                      topicTypes:
                                          TopicTypes.TERMS_AND_CONDITIONS,
                                    )));
                      },
                    text: TERMS_CONDITIONS,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    text: AND_TXT,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                      topicTypes: TopicTypes.PRIVACY_POLICY,
                                    )));
                      },
                    text: PRIVACY_POLICY,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: MEDIUM_FONT_SIZE)),
              ]),
        ),
      );

  /// LOGIN TXT(HEADING) IN CENTER
  Widget headingLblWidget(context) => Center(
        child: Text(
          LOGIN_TXT.toUpperCase(),
          style: getTextStyle(
            color: MAIN_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: LARGE_FONT_SIZE,
          ),
        ),
      );

  /// SUB LOGIN TXT(SUBHEADING) IN CENTER
  Widget subHeadingLblWidget(context) => Center(
        child: Text(
          ACCESS_YOUR_ACCOUNT,
          style: getTextStyle(
              fontSize: SMALL_PLUS_FONT_SIZE,
              fontWeight: FontWeight.w500,
              color: WHITE_COLOR),
        ),
      );
}
