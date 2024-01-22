import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/service/my_account/api/get_hub_manager_details.dart';
import 'package:nb_posx/core/tablet/theme_setting/theme_landscape.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/main.dart';
import 'package:nb_posx/utils/helpers/sync_helper.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../database/db_utils/db_instance_url.dart';
import '../../mobile/webview_screens/enums/topic_types.dart';
import '../../mobile/webview_screens/ui/webview_screen.dart';
import '../../service/login/api/login_api_service.dart';
import '../../service/product/api/products_api_service.dart';
import '../forgot_password/forgot_password_landscape.dart';
import '../home_tablet.dart';

class LoginLandscape extends StatefulWidget {
  final bool isUserLoggedIn;
  const LoginLandscape({Key? key, this.isUserLoggedIn = false})
      : super(key: key);

  @override
  State<LoginLandscape> createState() => _LoginLandscapeState();
}

class _LoginLandscapeState extends State<LoginLandscape> {
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  late BuildContext ctx;
  late String url;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: "branch_manager@testmail.com");
    _passCtrl = TextEditingController(text: "Admin@123");
    _urlCtrl = TextEditingController();
    _emailCtrl.text = "";
    _passCtrl.text = "";
    // _urlCtrl.text = instanceUrl;
    _getUrlKey();

    // _getAppVersion();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.fontWhiteColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 550,
                  padding: paddingXY(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      headingLblWidget(),
                      hightSpacer50,
                      // instanceUrlTxtboxSection(context),
                      // hightSpacer50,
                      subHeadingLblWidget(),
                      hightSpacer25,
                      emailTxtboxSection(),
                      hightSpacer20,
                      passwordTxtboxSection(),
                      hightSpacer20,
                      forgotPasswordSection(),
                      hightSpacer20,
                      changeInstanceUrlSection(),
                      hightSpacer20,
                      termAndPolicySection,
                      hightSpacer32,
                      loginBtnWidget(),
                      hightSpacer30
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// HANDLE LOGIN BTN ACTION
  Future<void> login(String email, String password, String url) async {
    if (email.isEmpty) {
      Helper.showPopup(context, "Please Enter Email");
    } else if (password.isEmpty) {
      Helper.showPopup(context, "Please Enter Password");
    } else {
      try {
        Helper.showLoaderDialog(context);
        CommanResponse response =
            await LoginService.login(email, password, url);

        if (response.status!) {
          log("$response");

          ///
          ///if it is a Windown Platfrom (run without isolates)
          ///
          if (Platform.isWindows) {
            if (widget.isUserLoggedIn) {
              await SyncHelper().loginFlow();
            } else {
              await SyncHelper().launchFlow(isUserLoggedIn);
            }
          }

          ///
          /// else run other platform android, tablet (run with isolates)
          ///
          else {
            await HubManagerDetails().getAccountDetails();
            if (widget.isUserLoggedIn) {
              // await CustomerService().getCustomers();
              await ProductsService().getCategoryProduct();
            }
            // Start isolate with background processing and pass the receivePort
            await useIsolate(isUserLoggedIn: true);
          }
          // if (isSuccess) {
          // Once the signal is received, navigate to ProductListHome
          Get.offAll(() => HomeTablet());
          // } else {
          //   // ignore: use_build_context_synchronously
          //   Helper.showSnackBar(context, "Synchronization failed");
          // }
        } else {
          if (!mounted) return;
          Helper.hideLoader(context);
          Helper.showPopup(context, response.message!);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        Helper.hideLoader(ctx);
        log('Exception Caught :: $e');
        // ignore: use_build_context_synchronously
        Helper.showSnackBar(context, SOMETHING_WRONG);
      }
    }
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

  ///Input field for entering the instance URL
  // Widget instanceUrlTxtboxSection(context) => Padding(
  //       // margin: horizontalSpace(),
  //       padding: smallPaddingAll(),
  //       child: SizedBox(
  //         height: 55,
  //         child: TextFieldWidget(
  //           boxDecoration: txtFieldBoxShadowDecoration,
  //           txtCtrl: _urlCtrl,
  //           verticalContentPadding: 16,
  //           hintText: URL_HINT,
  //         ),
  //       ),
  //     );

  /// LOGIN TXT(HEADING) IN CENTER
  ///
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
          LOGIN_TXT,
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: LARGE_FONT_SIZE,
          ),
        ),
      );

  /// EMAIL SECTION
  Widget emailTxtboxSection() => Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _emailCtrl,
            verticalContentPadding: 16,
            hintText: "Enter your email",
          ),
        ),
      );

  /// PASSWORD SECTION
  Widget passwordTxtboxSection() => Padding(
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _passCtrl,
            verticalContentPadding: 16,
            hintText: "Enter your password",
            password: true,
          ),
        ),
      );

  /// FORGOT PASSWORD SECTION
  Widget forgotPasswordSection() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();

              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordLandscape()));
            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                FORGET_PASSWORD_SMALL_TXT,
                style: getTextStyle(
                    color: AppColors.getPrimary(),
                    fontSize: LARGE_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );

  //CHANGE INSTANCE URL TEXTBOX SECTION
  Widget changeInstanceUrlSection() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();
              fetchDataAndNavigate();

              //Navigator.push(context,
              // MaterialPageRoute(builder: (context) => const ThemeChange()));
            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                CHANGE_INSTANCE_URL_TXT,
                style: getTextStyle(
                    color: AppColors.getPrimary(),
                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      );

//FETCH MASTER'S AND TRANSACTION
  Future<void> fetchDataAndNavigate() async {
    // log('Entering fetchDataAndNavigate');
    try {
      // Fetch the URL
      String url = await DbInstanceUrl().getUrl();
      // Clear the database
      await DBPreferences().delete();
      log("Cleared the DB");
      //to save the url
      await DbInstanceUrl().saveUrl(url);
      log("Saved Url:$url");
      // Navigate to a different screen
      // ignore: use_build_context_synchronously
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ThemeChangeTablet()),
          (route) => route.isFirst);

      // Save the URL again
      //await DBPreferences().savePreference('url', url);
    } catch (e) {
      // Handle any errors that may occur during this process
      log('Error: $e');
    }
  }

  /// TERM AND CONDITION SECTION
  Widget get termAndPolicySection => Padding(
        padding: horizontalSpace(x: 80),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: BY_SIGNING_IN,
              style: getTextStyle(
                  color: AppColors.getAsset(),
                  fontSize: LARGE_MINUS_FONT_SIZE,
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (isValidInstanceUrl()) {
                          Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      topicTypes:
                                          TopicTypes.TERMS_AND_CONDITIONS,
                                      apiUrl:
                                          "https://${_urlCtrl.text}/api/")));
                        } else {
                          Helper.showPopup(context, INVALID_URL);
                        }
                      },
                    text: TERMS_CONDITIONS,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
                        fontWeight: FontWeight.bold,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
                TextSpan(
                    text: AND_TXT,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
                        fontWeight: FontWeight.normal,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (isValidInstanceUrl()) {
                          Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      topicTypes: TopicTypes.PRIVACY_POLICY,
                                      apiUrl:
                                          "https://${_urlCtrl.text}/api/")));
                        } else {
                          Helper.showPopup(context, INVALID_URL);
                        }
                      },
                    text: PRIVACY_POLICY,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
                        fontWeight: FontWeight.bold,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
              ]),
        ),
      );

  /// LOGIN BUTTON
  Widget loginBtnWidget() => Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        child: ButtonWidget(
          onPressed: () async {
            await login(_emailCtrl.text, _passCtrl.text, url);
            log('Inside login.dart :$url');
          },
          title: "Log In",
          primaryColor: AppColors.getPrimary(),
          // width: MediaQuery.of(context).size.width - 150,
          height: 60,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  ///Method to check whether the API URL is correct.
  bool isValidInstanceUrl() {
    url = "https://$url/api/";
    return Helper.isValidUrl(url);
  }

  _getUrlKey() async {
    url = await DbInstanceUrl().getUrl();
    setState(() {});
  }
}
