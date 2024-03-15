import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/tablet/home_tablet.dart';
import 'package:nb_posx/database/db_utils/db_shift_management.dart';
import 'package:nb_posx/database/models/payment_info.dart';
import 'package:nb_posx/database/models/shift_management.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/widgets/button.dart';

class CloseShiftManagement extends StatefulWidget {
   final bool isShiftOpen;
  final RxString selectedView;
  const CloseShiftManagement({Key? key, this.isShiftOpen = true, required this.selectedView}) : super(key: key);

  @override
  CloseShiftManagementState createState() => CloseShiftManagementState();
}

class CloseShiftManagementState extends State<CloseShiftManagement> {
  bool isShiftOpen = false;
  late List<TextEditingController> controllers = [];
  ShiftManagement? closeShiftManagement;
late Future<ShiftManagement?> _future;
  late Future<ShiftManagement?> shiftManagementFuture;

  @override
 void initState() {
  _future = DbShiftManagement().getShiftManagement();
  super.initState();
   controllers = [];
}

  @override
void dispose() {
  super.dispose();
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.fontWhiteColor,
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width /3, 
          padding: paddingXY(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           hightSpacer10,
              closeShiftHeadingWidget(),
             hightSpacer120,
             hightSpacer30,
              FutureBuilder<ShiftManagement?>(
                future: _future,
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const CircularProgressIndicator();
                  // } 
                 if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var shiftManagement = snapshot.data;
                    if (shiftManagement != null) {
                      return paymentMethodsWidget(shiftManagement);
                    } else {
                      return  Text('Please Open the Shift first',
                      style:  TextStyle(
                            fontSize:LARGE_FONT_SIZE ,
                            color: AppColors.textandCancelIcon,
                          fontWeight: FontWeight.w500));
                    }
                  }
                },
              ),
            hightSpacer30,
              closeShiftBtnWidget(closeShiftManagement),
             hightSpacer30,
            ],
          ),
        ),
      ),
    ),
  );
}


//Close Shift Heading
 Widget closeShiftHeadingWidget() => Center(
      child: Text(
        CLOSE_SHIFT.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      ),
    );

//Payment methods of pos profile
 Widget paymentMethodsWidget(ShiftManagement shiftManagement) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: shiftManagement.paymentInfoList.length,
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 500,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.getshadowBorder()),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Padding(
              padding: leftSpace(x:10),
              child: Center(
                child: TextFormField(
                  // controller: controllers[index],
                  //autofocus: true,
                    keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColors.asset,
                    fontWeight: FontWeight.w500),
                     contentPadding: leftSpace(x: 21),
                    border: InputBorder.none,
                   // hintTextDirection: TextDirection.ltr,
                    hintText: 'Enter the closing ${shiftManagement.paymentsMethod[index].modeOfPayment} balance',
                  ),
                ),
              ),
            ),
          ),
          hightSpacer5,
          Text(
            'System Closing ${shiftManagement.paymentInfoList[index].paymentType} Balance: ${shiftManagement.paymentInfoList[index].amount}',
            style: const TextStyle(fontSize: 16,
            fontWeight: FontWeight.w500),
          ),
            hightSpacer30,
        ],
      );
    },
  );
}

//Button for Close Shift and clear the DB after closing the shift
  Widget closeShiftBtnWidget(ShiftManagement? closeShiftManagement) => ButtonWidget(
      colorTxt: AppColors.fontWhiteColor,
      isMarginRequired: false,
      width: 600,
      onPressed: () async {
        if (closeShiftManagement != null &&
            closeShiftManagement.posProfile.isNotEmpty &&
            closeShiftManagement.paymentInfoList.isNotEmpty) {
          List<String> amounts = controllers.map((controller) => controller.text).toList();

          // Create a list of PaymentInfo objects
          List<PaymentInfo> paymentInfoList = [];
          for (int i = 0; i < closeShiftManagement.paymentInfoList.length; i++) {
            PaymentInfo paymentInfo = PaymentInfo(
              paymentType: closeShiftManagement.paymentInfoList[i].paymentType,
              amount: amounts[i],
            );
            paymentInfoList.add(paymentInfo);
          }

          ShiftManagement shiftManagement = ShiftManagement(
            posProfile: closeShiftManagement.posProfile,
            paymentsMethod: closeShiftManagement.paymentsMethod,
            paymentInfoList: paymentInfoList,
          );
          log('Shift Info: $shiftManagement');

          // Save the shift management data before navigating to HomeTablet
        await DbShiftManagement().closeShiftManagement(shiftManagement);
      }
  //If Shift gets synced in ERP clear the DB of close shift 
 
  await DbShiftManagement().deleteShift();

      // Navigate to HomeTablet
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeTablet(isShiftCreated: false),
          ),
        );
      },
      title: CLOSE_SHIFT.toUpperCase(),
      primaryColor: AppColors.getPrimary(),
      height: 60,
      fontSize: LARGE_FONT_SIZE,
  );
}