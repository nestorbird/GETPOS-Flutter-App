//import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/configs/network_manager.dart';
import 'package:nb_posx/core/mobile/theme/theme_setting_screen.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/models/order_tax_template.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/sales_order_req.dart';
import 'package:nb_posx/database/models/sales_order_req_items.dart';
import 'package:nb_posx/database/models/taxes.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';

import 'constants/app_constants.dart';
import 'core/mobile/splash/view/splash_screen.dart';
import 'core/tablet/home_tablet.dart';
import 'database/db_utils/db_hub_manager.dart';
import 'database/models/attribute.dart';
import 'database/models/category.dart';
import 'database/models/customer.dart';
import 'database/models/hub_manager.dart';
import 'database/models/option.dart';
import 'database/models/order_item.dart';
import 'database/models/park_order.dart';
import 'database/models/product.dart';
import 'database/models/sale_order.dart';
import 'utils/helpers/sync_helper.dart';

bool isUserLoggedIn = false;
bool isTabletMode = false;

void main() async {
  NetworkManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  //Initializing hive database
  await Hive.initFlutter();

  //Registering hive database type adapters
  registerHiveTypeAdapters();
  isUserLoggedIn = await DbHubManager().getManager() != null;
  instanceUrl = await DbInstanceUrl().getUrl();
  log('Instance Url for hub manager: $instanceUrl');

  await SyncHelper().launchFlow(isUserLoggedIn);
  // check for device
  isTabletMode = Device.get().isTablet;
  if (isTabletMode) {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft],
    );
    runApp(const TabletApp());
  } else {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    runApp(const MobileApp());
  }
}

//Function to register all the Hive database adapters
void registerHiveTypeAdapters() {
  //Registering customer adapter
  Hive.registerAdapter(CustomerAdapter());

  //Registering hub manager adapter
  Hive.registerAdapter(HubManagerAdapter());

  //Registering sale order adapter
  Hive.registerAdapter(SaleOrderAdapter());

  //Registering ward adapter
  Hive.registerAdapter(CategoryAdapter());

  //Registering product adapter
  Hive.registerAdapter(ProductAdapter());

//Registering attribute adapter
  Hive.registerAdapter(AttributeAdapter());

//Registering Option adapter
  Hive.registerAdapter(OptionAdapter());

//Registering parkorder adapter
  Hive.registerAdapter(ParkOrderAdapter());

//Registering orderitem adapter
  Hive.registerAdapter(OrderItemAdapter());

//Registering taxes adapter
  Hive.registerAdapter(TaxesAdapter());

//Registering ordertax adapter
  Hive.registerAdapter(OrderTaxAdapter());

//Registering ordertaxtemplate adapter
  Hive.registerAdapter(OrderTaxTemplateAdapter());

//Registering salesorderrequestitems adapter
  Hive.registerAdapter(SaleOrderRequestItemsAdapter());

//Registering salesorderrequest adapter
  Hive.registerAdapter(SalesOrderRequestAdapter());
}

class MobileApp extends StatelessWidget {
  const MobileApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class TabletApp extends StatelessWidget {
  const TabletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isUserLoggedIn ? HomeTablet() : const ThemeChange(),
    );
  }
}


