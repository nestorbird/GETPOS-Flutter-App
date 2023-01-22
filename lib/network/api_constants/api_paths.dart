// ignore_for_file: constant_identifier_names

import '../../constants/app_constants.dart';
import '../api_helper/api_server.dart';

///Base API URL for development environment
const DEV_URL = 'https://pos.nestorbird.com/api/';
const DEV_ERP_URL = 'pos.nestorbird.com';
// const DEV_URL = 'https://agriboratest.nestorhawk.com/api/';

///Base API URL for staging/test environment
const TEST_URL = 'https://tst.erp.nbpos.com/api/';
const TEST_ERP_URL = 'pos.nestorbird.com';

///Base API URL for production environment
const PROD_URL = 'https://prd.erp.nbpos.com/api/';
const PROD_ERP_URL = 'pos.nestorbird.com';

///Default URL for POS instance
String instanceUrl = ENVIRONMENT == ApiServer.DEV
    ? DEV_ERP_URL
    : ENVIRONMENT == ApiServer.TEST
        ? TEST_ERP_URL
        : PROD_ERP_URL;

///Base API URL for production environment
// ignore: non_constant_identifier_names
final BASE_URL = ENVIRONMENT == ApiServer.DEV
    ? DEV_URL
    : ENVIRONMENT == ApiServer.TEST
        ? TEST_URL
        : PROD_URL;

///LOGIN API PATH
const LOGIN_PATH = 'method/nbpos.nbpos.api.login';

///CUSTOMERS LIST API PATH
const CUSTOMERS_PATH = 'method/nbpos.nbpos.api.get_customer_list_by_hubmanager';

const CUSTOMER_PATH = 'method/nbpos.nbpos.api.get_customer';

const CREATE_CUSTOMER_PATH = 'method/nbpos.nbpos.api.create_customer';

const NEW_GET_ALL_CUSTOMERS_PATH = 'method/nbpos.nbpos.api.get_all_customer';

//PRODUCTS LIST API PATH
const PRODUCTS_PATH = 'method/nbpos.nbpos.api.get_item_list_by_hubmanager';

//CREATE SALE ORDER PATH
const CREATE_SALES_ORDER_PATH = 'method/nbpos.nbpos.api.create_sales_order';

//TOPICS API (PRIVACY POLICY AND TERMS & CONDITIONS)
const TOPICS_PATH = 'method/nbpos.nbpos.api.privacy_policy_and_terms';

//FORGET PASSWORD PATH
const FORGET_PASSWORD = 'method/nbpos.nbpos.api.forgot_password';

//MY ACCOUNT API
const MY_ACCOUNT_PATH = 'method/nbpos.nbpos.api.get_details_by_hubmanager';

//SALES HISTORY PATH
const SALES_HISTORY = 'method/nbpos.nbpos.api.get_sales_order_list';

//MY ACCOUNT API
const CHANGE_PASSWORD_PATH = 'method/nbpos.nbpos.api.change_password';

// New Product api with category and variants
const CATEGORY_PRODUCTS_PATH =
    'method/nbpos.custom_api.item_variant_api.get_items';
