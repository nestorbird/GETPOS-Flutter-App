import 'dart:convert';

import 'package:nb_posx/widgets/custom_appbar.dart';

import '../../../../constants/app_constants.dart';

import '../../../../network/api_helper/api_status.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../enums/topic_types.dart';
import '../service/topic_api_service.dart';

class WebViewScreen extends StatefulWidget {
  final TopicTypes topicTypes;

  const WebViewScreen({Key? key, required this.topicTypes}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String parsedHtml = '';
  String apiResponse = '';
  WebViewController? _webViewController;
  String title = "";

  @override
  void initState() {
    super.initState();

    if (widget.topicTypes == TopicTypes.PRIVACY_POLICY) {
      title = "Privacy Policy";
    } else {
      title = "Terms & Conditions";
    }

    getTopicData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          CustomAppbar(title: title, hideSidemenu: true),
          Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (_webController) {
                      _webViewController = _webController;
                    },
                  )))
        ],
      )),
    );
  }

  //Function to get the data from api for privacy policy and T&C
  void getTopicData() async {
    //Call to api service as the topic type
    var response = await TopicDataService.getTopicData(widget.topicTypes);

    //Execute when internet is not available
    if (response.apiStatus == ApiStatus.NO_INTERNET) {
      //Show the message that internet is not available
      final snackBar = SnackBar(
          content: Text(
        NO_INTERNET,
        style: getTextStyle(
            fontSize: MEDIUM_MINUS_FONT_SIZE, fontWeight: FontWeight.normal),
      ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //Now pop out the screen, as internet is not available
      Navigator.pop(context);
    }
    //If internet is available then load the html data from api in webview
    else {
      apiResponse = response.message;
      _loadHtml();
    }
  }

  ///Function to load the html data into webview
  void _loadHtml() async {
    //Converting the html data from api into Uri and then to string
    var data = Uri.dataFromString(apiResponse,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();

    //Loading the html string into webview
    _webViewController!.loadUrl(data);
    setState(() {});
  }
}
