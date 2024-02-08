//import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/configs/local_notification_service.dart';
import 'package:nb_posx/configs/network_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/tablet/theme_setting/theme_landscape.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/models/order_tax_template.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/sales_order_req.dart';
import 'package:nb_posx/database/models/sales_order_req_items.dart';
import 'package:nb_posx/database/models/taxes.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:path_provider/path_provider.dart';
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
  await init();
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
  // await Hive.initFlutter();

  isUserLoggedIn = await DbHubManager().getManager() != null;
  //isUserLoggedIn = await DBPreferences().getPreference('MANAGER');

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
      home: isUserLoggedIn ? HomeTablet() : const ThemeChangeTablet(),
    );
  }
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService().initNotification();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  NetworkManager.init();
  // //Initializing hive database
  await DBPreferences().openPreferenceBox();

  registerHiveTypeAdapters();
  getColors();
  isUserLoggedIn = await DBPreferences().getPreference(SuccessKey) == 1;
  if (isUserLoggedIn) {
    await useIsolate(isUserLoggedIn: isUserLoggedIn);
  }
}

useIsolate({bool isUserLoggedIn = false}) async {
  var rootToken = RootIsolateToken.instance!;
  WidgetsFlutterBinding.ensureInitialized();
  //final appDocumentDirectory = await getApplicationDocumentsDirectory();

// Hive.init(appDocumentDirectory.path);

  DartPluginRegistrant.ensureInitialized();
  if (isUserLoggedIn) {
    LocalNotificationService().showNotification(
        id: 0,
        title: 'Background Sync',
        body: 'Please wait Background sync work in progess');
  }
  final ReceivePort receivePort = ReceivePort();
  try {
    await Isolate.spawn(runHeavyTaskWithIsolate, [
      receivePort.sendPort,
      rootToken,
      isUserLoggedIn,
    ]);
  } on Object {
    debugPrint('Isolate Failed');
    receivePort.close();
  }
  final response = await receivePort.first;
  log('Isolate Result: $response');
  // if (response == true) {
  if (isUserLoggedIn) {
    LocalNotificationService().showNotification(
        id: 1, title: 'Background Sync', body: 'Background Sync completed.');
  }
  log('Isolate Result: $response');
  // return true;
  // }
  //  else {
  //   LocalNotificationService().showNotification(
  //       id: 1, title: 'Background Sync', body: 'Background Sync failed.');
  //   return false;
  // }
}

Future<dynamic> runHeavyTaskWithIsolate(
  List<dynamic> args,
) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[1]);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  DartPluginRegistrant.ensureInitialized();
  registerHiveTypeAdapters();

  try {
    SendPort resultPort = args[0];
    log("Args :: ${args[0]}");
    log("Args :: ${args[1]}");
    log("Args :: ${args[2]}");
    log("Isolate started");
    if (args[2]) {
      debugPrint("inside launch flow");
      await SyncHelper().launchFlow(args[2]);
    } else {
      debugPrint("inside login flow");
      await SyncHelper().loginFlow();
    }

    log("Isolates Finished");
    Isolate.exit(resultPort, true);
  } catch (e) {
    log(e.toString());
  }
}

getColors() async {
  int primaryColor =
      int.tryParse(await DBPreferences().getPreference(PRIMARY_COLOR)) ??
          0xFFDC1E44;

  int secondaryColor =
      int.tryParse(await DBPreferences().getPreference(SECONDARY_COLOR)) ??
          0xFF62B146;

  int accentColor =
      int.tryParse(await DBPreferences().getPreference(ACCENT_COLOR)) ??
          0xFF707070;
  int textandCancelIcon =
      int.tryParse(await DBPreferences().getPreference(TEXT_AND_CANCELICON)) ??
          0xFF000000;
  int shadowBorder =
      int.tryParse(await DBPreferences().getPreference(SHADOW_BORDER)) ??
          0xFFC7C5C5;
  int hintText = int.tryParse(await DBPreferences().getPreference(HINT_TEXT)) ??
      0xFFF3F2F5;
  int fontWhiteColor =
      int.tryParse(await DBPreferences().getPreference(FONT_WHITE_COLOR)) ??
          0xFFFFFFFF;
  int parkOrderButton =
      int.tryParse(await DBPreferences().getPreference(PARK_ORDER_BUTTON)) ??
          0xFF4A4A4A;
  int active =
      int.tryParse(await DBPreferences().getPreference(ACTIVE)) ?? 0xFFFEF9FA;

  AppColors.primary = Color(primaryColor);
  AppColors.secondary = Color(secondaryColor);
  AppColors.asset = Color(accentColor);
  AppColors.textandCancelIcon = Color(textandCancelIcon);
  AppColors.shadowBorder = Color(shadowBorder);
  AppColors.hintText = Color(hintText);
  AppColors.fontWhiteColor = Color(fontWhiteColor);
  AppColors.parkOrderButton = Color(parkOrderButton);
  AppColors.active = Color(active);
}
