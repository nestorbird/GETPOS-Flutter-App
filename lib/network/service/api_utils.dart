import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_constants.dart';
import '../../database/db_utils/db_constants.dart';
import '../../database/db_utils/db_preferences.dart';
import '../../utils/helper.dart';
import '../api_constants/api_paths.dart';
import '../api_helper/api_exception.dart';

///[APIUtils] class to provide utility for HTTP methods like get, post, patch, etc.
class APIUtils {
  ///[getRequest] method to use get API call to server.
  ///param : [apiUrl] -> API URL
  ///param : [headers] -> API headers for the [apiUrl]
  static Future<Map<String, dynamic>> getRequest(String apiUrl) async {
    try {
      //Remote Call to API with url and headers
      http.Response apiResponse = await http.get(_apiPath(apiUrl));

      //Checking for the response code and handling the result.
      return _returnResponse(apiResponse);
    }

    //Handling the condition when socket exception received.
    on SocketException {
      throw FetchDataException(FAILURE_OCCURED);
    }
  }
  static Future<Map<String, dynamic>> getRequestVerify(String apiUrl) async {
    try {
      //Remote Call to API with url and headers
      http.Response apiResponse = await http.get(_apiPathVerify(apiUrl));

      //Checking for the response code and handling the result.
      return _returnResponse(apiResponse);
    }

    //Handling the condition when socket exception received.
    on SocketException {
      throw FetchDataException(FAILURE_OCCURED);
    }
  }
  static Future<Map<String, dynamic>> getRequestWithCompleteUrl(
      String apiUrl) async {
    try {
      //Remote Call to API with url and headers
      http.Response apiResponse = await http.get(Uri.parse(apiUrl));

      //Checking for the response code and handling the result.
      return _returnResponse(apiResponse);
    }

    //Handling the condition when socket exception received.
    on SocketException {
      throw FetchDataException(FAILURE_OCCURED);
    }
  }

  ///[postRequest] function for GET requests with auth token as header
  ///and request type as form data.
  ///param : [apiUrl] -> API URL
  static Future<Map<String, dynamic>> postRequest(
      String apiUrl, dynamic requestBody,
      {bool enableHeader = true}) async {
    try {
      Helper.printJSONData(requestBody);

      //Getting response from api call
      http.Response apiResponse = await http.post(_apiPath(apiUrl),
          body: jsonEncode(requestBody),
          headers: enableHeader ? await _headers() : {});
      print(apiResponse);

      //Checking for the response code and handling the result.
      return _returnResponse(apiResponse);
    }

    //Handling the condition when socket exception received.
    on SocketException {
      throw FetchDataException(FAILURE_OCCURED);
    }
  }

  static Future<Map<String, dynamic>> getRequestWithHeaders(
      String apiUrl) async {
    try {
      //Remote Call to API with url and headers
      http.Response apiResponse =
          await http.get(_apiPath(apiUrl), headers: await _headers());

      //Checking for the response code and handling the result.
      return _returnResponse(apiResponse);
    }

    //Handling the condition when socket exception received.
    on SocketException {
      throw FetchDataException(FAILURE_OCCURED);
    }
  }

  static Uri _apiPath(String url) {
    //Parsing the apiURl to Uri
    Uri uri = Uri.parse(instanceUrl + url);
    log('API URL :: $uri');
    return uri;
  }
 static Uri _apiPathVerify(String url) {
    //Parsing the apiURl to Uri
    Uri uri = Uri.parse( url);
    log('API URL :: $uri');
    return uri;
  }

  static Future<Map<String, String>> _headers() async {
    //Getting auth token
    String authToken = await getToken();
    debugPrint("TOKEN: $authToken");
    //Creating http headers for api
    Map<String, String> headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json'
    };
    return headers;
  }

  ///Function to handle the response as per status code from api server
  static dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        Helper.printJSONData(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnAuthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            "$SERVER_COMM_EXCEPTION : ${response.statusCode}");
    }
  }

  ///Function for building the auth token to be used in api headers
  ///using API Key and API Secret.
  static Future<String> getToken() async {
    //Creating object for DBPreferences
    DBPreferences dbPreferences = DBPreferences();

    //Getting API Key
    String apiKey = await dbPreferences.getPreference(ApiKey);

    //Getting API Secret
    String apiSecret = await dbPreferences.getPreference(ApiSecret);

    //Returning the final auth token as result
    return "token $apiKey:$apiSecret";
  }
}
