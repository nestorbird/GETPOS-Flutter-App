//****************************//
// String Constants of the app
//***************************//

// ignore_for_file: constant_identifier_names

import 'dart:ui';

import '../network/api_helper/api_server.dart';

const APP_NAME = 'NB POS';
String appCurrency = '₹';
const PLEASE_WAIT_TXT = 'Please wait...';

const ENVIRONMENT = ApiServer.DEV;
const OFFLINE_DATA_FOR = 7;
const APP_VERSION = "App version";
const APP_VERSION_FALLBACK = "1.0";
//THEME CHANGE
const invalidErrorText = "Invalid Url";
const notAnActiveUrl = "Not an active Url";
//LOGIN SCREEN
const invalidPasswordMsg =
    "Enter at least 6 digits, should be one special characters,one uppercase,one lowercase,one digit.";
//  "Invalid Password \n1. Include at least 8 digits and three special characters \n2. Include at least one upper case characters (A-Z)\n3. Include at least one lower case character (a-z)\n4. Include a number (0-9)\n5. Include a symbol (!, #, \$, etc.)";
const passwordMismatch = "Password is mismatch";
const LOGIN_TXT = 'Log In';

const ACCESS_YOUR_ACCOUNT = 'Access your account';
const EMAIL_TXT = 'Email';
const PASSWORD_TXT = 'Password';
const URL_TXT = 'URL';
const URL_HINT = 'Enter ERP URL';
const EMAIL_HINT = 'Enter your email';
const PASSWORD_HINT = 'Enter your password';
const FORGET_PASSWORD_SMALL_TXT = 'Forgot Password?';
const BY_SIGNING_IN = 'By signing, you agree to our ';
const TERMS_CONDITIONS = 'Terms & Conditions ';
const AND_TXT = 'and ';
const PRIVACY_POLICY = 'Privacy Policy ';
const SOMETHING_WRONG = 'Something went wrong. Please try again';
const INVALID_EMAIL = 'Please enter valid email';
const INVALID_PASSWORD = 'Password should be at least of 6 characters';
const INVALID_URL = 'Please enter valid ERP URL';
const CLOSE_APP_QUESTION = 'Do you want to close the app?';
const OPTION_YES = 'Yes';
const OPTION_NO = 'No';
const OPTION_OK = 'Ok';
const OPTION_CANCEL = 'Cancel';

//HOME SCREEN

const HOME_TXT = 'Home';
const WELCOME_BACK = 'Welcome Back,';
const SYNC_NOW_TXT = 'Sync now';
const CREATE_ORDER_TXT = 'Create Order'; //Create Order Screen
const PRODUCTS_TXT = 'Products';
const CUSTOMERS_TXT = 'Customers';
const MY_ACCOUNT_TXT = 'My Account';
const SALES_HISTORY_TXT = 'Order History';
const FINANCE_TXT = 'Finance';

//CREATE ORDER SCREEN

const SELECT_CUSTOMER_TXT = 'Select Customer'; //Select Customer Screen
const ADD_PRODUCT_TXT = 'Add Product';
const OUT_OF_STOCK = 'Out of stock'; //Create Order Screen
const ITEMS_TXT = 'Items';
const PROCEED_TO_NXT_TXT = 'PROCCED TO NEXT';
const CHECKOUT_TXT = 'CHECKOUT';
const SELECT_CUSTOMER_ERROR = 'Please select the customer.';
const SELECT_PRODUCT_ERROR = 'Please add the products in cart.';
const SEARCH_PRODUCT_HINT_TXT = 'Search product / category';

//SELECT CUSTOMER SCREEN

const SEARCH_HINT_TXT = 'Enter customer mobile number';
const SEARCH_CUSTOMER_MSG_TXT = 'Type in customer mobile number...';
const SELECT_CONTINUE_TXT = 'SELECT & CONTINUE';
const CONTINUE_TXT = 'CONTINUE';
// PRODUCT SCREEN
const SEARCH_PRODUCT_TXT = 'Search product / category';

//ADD PRODUCTS SCREEN
const ADD_PRODUCT_TITLE = 'Products';
const ADD_CONTINUE = 'ADD & CONTINUE';
const INSUFFICIENT_STOCK_ERROR = 'Insufficient stock for this product.';
const ADD_PRODUCTS_SEARCH_TXT = 'Search Product';
const ADD_PRODUCTS_AVAILABLE_STOCK_TXT = 'Available stock';
const ADD_PRODUCTS_STOCK_UPDATE_ON_TXT = 'Stock update on';

//CREATE ORDER SCREEN

const CHANGE_CUSTOMER_TXT = 'Change customer';
const ADD_MORE_PRODUCTS = 'Add More Product';

//CHECKOUT SCREEN

const CHECKOUT_TXT_SMALL = 'Checkout';
const CASH_PAYMENT_TXT = 'Cash';
const MPESA_PAYMENT_TXT = 'M-Pesa';
const EWALLET_PAYMENT_TXT = 'eWallet';
const CARD_PAYMENT_TXT = 'Card';
const CONFIRM_PAYMENT = 'Pay now';
const CASH_PAYMENT_MSG =
    'Take the cash from the customer and click on confirm payment button';
const TRANSACTION_TXT = 'Transaction ID';
const ENTER_UR_TRANSACTION_ID = 'Enter your transaction ID';
const SELECT_PAYMENT_TYPE = 'Please select the payment type.';
const ENTER_MPESA_TRANS_ID =
    'Please enter 10 alphanumeric M-Pesa transaction ID';

//SALE SUCCESSFUL SCREEN

const SALES_SUCCESS_TXT = 'Order Successful';
const RETURN_TO_HOME_TXT = 'Home Page';

//MY ACCOUNT SCREEN

const CHANGE_PASSWORD = 'Change Password';
const LOGOUT_TITLE = 'Logout';
const LOGOUT_QUESTION = 'Do you really want to logout?';
const OFFLINE_ORDER_MSG = 'Please sync your offline order first?';

//SALES HISTORY SCREEN
const PARKED_ORDER_ID = 'Parked ID';
const SALES_ID = 'Order ID';
const ITEM_CODE_TXT = 'Item code';
const ITEM_TXT = 'Items';

//SALES DETAILS SCREEN

const SALES_DETAILS_TXT = 'Order Details';
const SALE_AMOUNT_TXT = 'Order Amount';
const DATE_TIME = 'Date & Time';
const CUSTOMER_INFO = 'Customer Info';
const ITEMS_SUMMARY = 'Item(s) Summary';
const PAYMENT_STATUS = 'Status';

//FINANCE SCREEN
const FINANCE_TITLE = 'Finance';
const CASH_BALANCE_TXT = 'Cash Balance';

//FORGOT PASSWORD SCREEN
const FORGOT_PASSWORD_TITLE = 'Forgot password';
const FORGOT_EMAIL_TXT = 'Email';
const FORGOT_EMAIL_HINT = 'Enter your registered email';
const FORGOT_BTN_TXT = 'Continue';
const FORGOT_TXT_FIELD_EMPTY = 'Please provide registered email ID';
const FORGOT_SUB_MSG =
    'A reset password link will be sent to your registered email ID to reset password.';

//VERIFY OTP SCREEN
const VERIFY_OTP_TITLE = 'Verification link sent';
const VERIFY_OTP_MSG =
    'A reset password link has been sent to your registered email id, kindly verify.';
const VERIFY_OTP_HINT = 'Enter otp';
const VERIFY_OTP_BTN_TXT = 'Back';

//CHANGE PASSWORD SCREEN
const CHANGE_PASSWORD_TITLE = 'Change Password';
const CHANGE_PASSWORD_OTP_VERIFY_MSG = 'OTP verified successfully.';
const CHANGE_PASSWORD_SET_MSG = 'Set new password';
const CHANGE_NEW_PASSWORD_HINT = 'Enter new password';
const CHANGE_CONFIRM_PASSWORD_HINT = 'Re-enter new password';
const CHANGE_PASSWORD_BTN_TXT = 'Change Password';
const CHANGE_PASSWORD_INVALID_TEXT =
    'New Password And Confirm Password Is Not Matched';

//PASSWORD UPDATED SCREEN
const PASSWORD_UPDATED_TITLE = 'Password Updated!';
const PASSWORD_UPDATED_MSG = 'Password Has Been Updated Successfully';
const PASSWORD_UPDATED_BTN_TXT = 'Back To Home';

//SPLASH SCREEN
const POWERED_BY_TXT = 'Powered by NestorBird';

//GENERAL MESSAGE CONSTANTS
const NO_INTERNET = 'No internet connection';
const NO_INTERNET_LOADING_DATA_FROM_LOCAL =
    'No internet connection. Loading data from local storage.';
const SOMTHING_WRONG_LOADING_LOCAL =
    'Something went wrong. Loading data from local storage.';
const NO_DATA_FOUND = 'No data found.';
const SUCCESS = 'success';

const NO_INTERNET_CREATE_ORDER_SYNC_QUEUED =
    'No internet available. Create order sync will take place later...';

const WEAK_PASSWORD = 'Password you choose is too weak';
const SOMETHING_WENT_WRONG = 'Something went wrong, Please try later...';
const FAILURE_OCCURED = 'Failure occured';
const SERVER_COMM_EXCEPTION =
    'Error occured while communication with server with StatusCode';

// ERROR MSG
const NO_PRODUCTS_FOUND_MSG = 'No products found';
const NO_ORDERS_FOUND_MSG = 'No orders found';

// height width margin constants
const double APP_LOGO_WIDTH = 200;
const double CARD_BORDER_SIDE_RADIUS_10 = 10;
const double CARD_BORDER_SIDE_RADIUS_08 = 08;
const double BORDER_CIRCULAR_RADIUS_06 = 06;
const double BORDER_CIRCULAR_RADIUS_07 = 07;
const double BORDER_CIRCULAR_RADIUS_08 = 08;
const double BORDER_CIRCULAR_RADIUS_10 = 10;
const double BORDER_CIRCULAR_RADIUS_20 = 20;
const double BORDER_CIRCULAR_RADIUS_30 = 30;
const double BORDER_WIDTH = 0.3;

// HOME
const double HOME_PROFILE_PIC_WIDTH = 130;
const double HOME_PROFILE_PIC_RADIUS = 40;
const double HOME_PROFILE_PIC_MARGIN = 18;
const double HOME_TILE_HORIZONTAL_SPACING = 24;
const double HOME_TILE_VERTICAL_SPACING = 20;
const double HOME_TILE_PADDING_LEFT = 24;
const double HOME_TILE_PADDING_TOP = 16;
const double HOME_TILE_PADDING_RIGHT = 24;
const double HOME_TILE_PADDING_BOTTOM = 32;
const double HOME_TILE_ASSET_HEIGHT = 90;
const int HOME_TILE_GRID_COUNT = 2;
const double HOME_USER_PROFILE_LEFT_SPACING = 20;
const double HOME_SWITCH_HEIGHT = 20;
const double HOME_SWITCH_WIDTH = 50;
const double HOME_SWITCH_BORDER_RADIUS = 25;
const double HOME_SWITCH_TOGGLE_SIZE = 10;

//FINANCE PADDINGS
const double FINANCE_PADDING_LEFT = 16;
const double FINANCE_PADDING_BOTTOM = 8;

// MY ACCOUNT
const double MY_ACCOUNT_ICON_WIDTH = 20;
const double MY_ACCOUNT_ICON_PADDING_LEFT = 16;
const double MY_ACCOUNT_ICON_PADDING_TOP = 8;
const double MY_ACCOUNT_ICON_PADDING_RIGHT = 24;
const double MY_ACCOUNT_ICON_PADDING_BOTTOM = 8;

// SALE SUCCESS
const double SALE_SUCCESS_IMAGE_HEIGHT = 150;
const double SALE_SUCCESS_IMAGE_WIDTH = 150;

// FONT SIZES
const double LARGE_FONT_SIZE = 20;
const double LARGE_PLUS_FONT_SIZE = 22;
const double SMALL_MINUS_FONT_SIZE = 8;
const double SMALL_FONT_SIZE = 10;
const double SMALL_PLUS_FONT_SIZE = 12;
const double MEDIUM_MINUS_FONT_SIZE = 13;
const double MEDIUM_FONT_SIZE = 14;
const double MEDIUM_PLUS_FONT_SIZE = 16;
const double LARGE_MINUS_FONT_SIZE = 18;

//Custom Text Color
const CUSTOM_TEXT_COLOR = Color.fromARGB(255, 87, 86, 86);
