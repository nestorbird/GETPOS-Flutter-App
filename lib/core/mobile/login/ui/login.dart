// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/mobile/home/ui/product_list_home.dart';
import 'package:nb_posx/core/mobile/theme/theme_setting_screen.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_customer.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_order_item.dart';
import 'package:nb_posx/database/db_utils/db_order_tax.dart';
import 'package:nb_posx/database/db_utils/db_order_tax_template.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import 'package:nb_posx/database/db_utils/db_sale_order.dart';
import 'package:nb_posx/main.dart';
import 'package:nb_posx/utils/helpers/sync_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../../constants/asset_paths.dart';
import '../../../service/login/api/login_api_service.dart';
import '../../../service/my_account/api/get_hub_manager_details.dart';
import '../../../service/product/api/products_api_service.dart';
import '../../forgot_password/ui/forgot_password.dart';
import '../../webview_screens/enums/topic_types.dart';
import '../../webview_screens/ui/webview_screen.dart';

class Login extends StatefulWidget {
  final bool isUserLoggedIn;
  const Login({Key? key, this.isUserLoggedIn = false}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailCtrl, _passCtrl;
  late String url;
  String? version;
  String prefix = "";

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: "branch_manager@testmail.com");
    _passCtrl = TextEditingController(text: "Admin@123");
    _getUrlKey();

    // url = instanceUrl;
     var dbPreferences = DBPreferences();
 dbPreferences.getPreference(SSL_PREFIX);
    _getAppVersion();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  /* _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Close App Confirmation'),
          content: Text('Are you sure you want to close the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can add your code here to exit the app
                // For example, you can use SystemNavigator.pop() to exit the app.
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                children: [
                  hightSpacer50,
                  Image.asset(App_ICON, width: 100, height: 100),
                  hightSpacer50,
                  // instanceUrlTxtboxSection(context),
                  // hightSpacer20,
                  headingLblWidget(context),
                  hightSpacer15,
                  emailTxtBoxSection(context),
                  hightSpacer10,
                  passwordTxtBoxSection(context),
                  hightSpacer10,
                  forgotPasswordSection(context),
                  hightSpacer10,
                  changeInstanceUrlSection(context),
                  hightSpacer15,
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
              ),
            )),
      )),
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
        log("$response");

        if (response.status!) {
          log("$response");
          // dataLoadInLandingScreen();
          // await ProductsService().getCategoryProduct();
          await HubManagerDetails().getAccountDetails();
          if (widget.isUserLoggedIn) {
            await ProductsService().getCategoryProduct();
          }
          Helper.hideLoader(context);
          // Start isolate with background processing and pass the receivePort
         await useIsolate(isUserLoggedIn: true);
          // if (isSuccess) {
          // Once the signal is received, navigate to ProductListHome
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProductListHome(
                        isAppLoggedIn: true,
                      )));
          // } else {
          //   Helper.showSnackBar(context, "Synchronization failed");
          // }
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
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "$APP_VERSION - ${packageInfo.version}";
      log('Version:$version');
    });
  }

  /// LOGIN BUTTON
  Widget loginBtnWidget(context) => Center(
        child: ButtonWidget(
          onPressed: () async {
            // await DbInstanceUrl().deleteUrl();
            //  String url = "https://${_urlCtrl.text}/api/";
            await login(_emailCtrl.text, _passCtrl.text, url);
            log('Inside login.dart :$url');
          },
          title: LOGIN_TXT,
          primaryColor: AppColors.getPrimary(),
          width: MediaQuery.of(context).size.width,
        ),
      );

  /// EMAIL SECTION
  Widget emailTxtBoxSection(context) => Container(
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
  Widget passwordTxtBoxSection(context) => Container(
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
                    color: AppColors.getPrimary(),
                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      );

  /// CHANGE INSTANCE URL SECTION
  Widget changeInstanceUrlSection(context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();

              fetchDataAndNavigate();

            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                CHANGE_INSTANCE_URL_TXT,
                style: getTextStyle(
                    color: AppColors.getPrimary(),
                    fontSize: MEDIUM_FONT_SIZE,
                    fontWeight: FontWeight.bold),
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
                  color: AppColors.getAsset(),
                  fontSize: MEDIUM_FONT_SIZE,
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                     
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                        topicTypes:
                                            TopicTypes.TERMS_AND_CONDITIONS,
                                        apiUrl: "$prefix://$url/api/",
                                      )));
                     
                      },
                    text: TERMS_CONDITIONS,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
                        fontWeight: FontWeight.bold,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    text: AND_TXT,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
                        fontWeight: FontWeight.normal,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                    
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                        topicTypes: TopicTypes.PRIVACY_POLICY,
                                        apiUrl: "$prefix://$url/api/",
                                      )));
                      
                      },
                    text: PRIVACY_POLICY,
                    style: getTextStyle(
                        color: AppColors.getAsset(),
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
            color: AppColors.getPrimary(),
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
              color: AppColors.getTextandCancelIcon()),
        ),
      );

  ///Method to check whether the API URL is correct.
  bool isValidInstanceUrl() {
    url = "$prefix://$url/api/";
    return Helper.isValidUrl(url);
  }

  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);

    return false;
  }

  dataLoadInLandingScreen() async {
    await ProductsService().getCategoryProduct();
    await HubManagerDetails().getAccountDetails();
    setState(() {});
  }

  Future<void> fetchDataAndNavigate() async {
    // log('Entering fetchDataAndNavigate');
    try {
      // Fetch the URL
      String url = await DbInstanceUrl().getUrl();
      log(url);
      // Clear the database
      SyncHelper().logoutFlow();
      log("Cleared the DB");
      //to save the url
     // await DbInstanceUrl().saveUrl(url);
     // log("Saved Url:$url");

     

    
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ThemeChange()),
          (route) => route.isFirst);

      // Save the URL again
      //await DBPreferences().savePreference('url', url);
    } catch (e) {
      // Handle any errors that may occur during this process
      log('Error: $e');
    }
  }

  _getUrlKey() async {
    url = await DbInstanceUrl().getUrl();
    setState(() {});
  }
}
