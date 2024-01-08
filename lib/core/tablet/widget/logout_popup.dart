import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/database/db_utils/db_customer.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_sale_order.dart';
import 'package:nb_posx/utils/helper.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/button.dart';
import '../login/login_landscape.dart';

class LogoutPopupView extends StatefulWidget {
  const LogoutPopupView({Key? key}) : super(key: key);

  @override
  State<LogoutPopupView> createState() => _LogoutPopupViewState();
}

class _LogoutPopupViewState extends State<LogoutPopupView> {
  /// LOGIN BUTTON
  Widget get cancelBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => Get.back(),
          title: "Cancel",
          primaryColor: AppColors.getAsset(),
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  Widget get logoutConfirmBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: ()
             => handleLogout(),
    //       {
    //       // Close the current popup
    //   Navigator.pop(context);
      
    //   // Call the handleLogout function
    //   handleLogout();
    // },
          title: "Logout",
          primaryColor:AppColors.getPrimary(),
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  // Future<void> handleLogout() async {
  //   await SyncHelper().logoutFlow();
  //   Get.offAll(() => const LoginLandscape());
  // }

 @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Confirm",
              style: getTextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          hightSpacer10,
          Text("Are you sure, you want to logout",
              style: getTextStyle(
                  fontSize: LARGE_FONT_SIZE, fontWeight: FontWeight.w500)),
          hightSpacer10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cancelBtnWidget, logoutConfirmBtnWidget],
          ),
        ],
      ),
    );
  }


//  Future<void> handleLogout() async {
 
//    var offlineOrders = await DbSaleOrder().getOfflineOrders();
//   // var offlineOrders = await DbSaleOrder().getOrders();
//     if (offlineOrders.isEmpty) {
     
//       if (!mounted) return;
//       var res = await Helper.showConfirmationPopup(
//           context, LOGOUT_QUESTION, OPTION_YES,
//           hasCancelAction: true);
//       if (res != OPTION_CANCEL.toLowerCase()) {
        
//         //check this later
//       // await SyncHelper().logoutFlow();

//       await fetchMasterAndDeleteTransaction();
//       }
//     } else {
//       if (!mounted) return;
//  bool isInternetAvailable = await Helper.isNetworkAvailable();
//   if (offlineOrders.isNotEmpty) {
//    //Navigator.of(context, rootNavigator: true).pop('dialog');
//    Navigator.pop(context);
//       var res= await Helper.showConfirmationPopup(context, OFFLINE_ORDER_MSG, OPTION_OK);
//       if (res == OPTION_OK.toLowerCase() || isInternetAvailable == false) {
//       //  Navigator.of(context, rootNavigator: true).pop('dialog');
// var resp = await Helper.showConfirmationPopup(context, GET_ONLINE_MSG, OPTION_OK);
 
// if (resp ==OPTION_OK.toLowerCase()&& isInternetAvailable) {
//   // await   _checkForSyncNow();
//  //for testing only : await fetchDataAndNavigate();
//   // await fetchMasterAndDeleteTransaction();
//  var response = await SyncHelper().syncNowFlow();
 
//  if(response== true) {
  
//   // ignore: use_build_context_synchronously
//   Get.offAll(() => const LoginLandscape());
//  }
//   await DbSaleOrder().modifySevenDaysOrdersFromToday();

// } 
//       }
//       }
//     }

//   }
Future<void> handleLogout() async {
  var offlineOrders = await DbSaleOrder().getOfflineOrders();

  if (offlineOrders.isEmpty) {
    if (!mounted) return;
    var res = await Helper.showConfirmationPopup(
        context, LOGOUT_QUESTION, OPTION_YES,
        hasCancelAction: true);

    if (res != OPTION_CANCEL.toLowerCase()) {
      await fetchMasterAndDeleteTransaction();
    }
  } else {
    if (!mounted) return;
 // Navigator.pop(context);
    // Show the popup indicating presence of offline orders
    var res = await Helper.showConfirmationPopup(context, OFFLINE_ORDER_MSG, OPTION_OK);

    if (res == OPTION_OK.toLowerCase()) {
      // Check internet connectivity
      bool isInternetAvailable = await Helper.isNetworkAvailable();
      
      if (!isInternetAvailable) {
        // Show popup for no internet
        var resp = await Helper.showConfirmationPopup(context, GET_ONLINE_MSG, OPTION_OK);
        
       // if (resp == OPTION_OK.toLowerCase()) {
          // Handle the action if the user chooses to continue without internet
          // This could be showing them how to get online or any other action
      //  }
     // } else {
        // If internet is available after acknowledging the offline orders, synchronize
        var response = await SyncHelper().syncNowFlow();
        
        if (response == true &&resp == OPTION_OK.toLowerCase()&&  isInternetAvailable) {
          Get.offAll(() => const LoginLandscape());
        }
       
        await DbSaleOrder().modifySevenDaysOrdersFromToday();
      }
    }
  }
}


 
   Future<void> fetchMasterAndDeleteTransaction() async {
    // log('Entering fetchDataAndNavigate');
    try {
      // Fetch the URL
      String url = await DbInstanceUrl().getUrl();
      // Clear the transactional data
    // await DBPreferences().deleteTransactionData;
       await DbCustomer().deleteCustomer(DeleteCustomers);
       await DbSaleOrder().delete();
      log("Cleared the transactional data");
      //to save the url
      await DbInstanceUrl().saveUrl(url);
      log("Saved Url:$url");
      // Navigate to a different screen
      // ignore: use_build_context_synchronously
       Get.offAll(() => const LoginLandscape());
 

      // Save the URL again
      //await DBPreferences().savePreference('url', url);
    } catch (e) {
      // Handle any errors that may occur during this process
      log('Error: $e');
    }
  }

}
