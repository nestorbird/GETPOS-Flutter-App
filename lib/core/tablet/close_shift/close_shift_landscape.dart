import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// for json decoding
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/widgets/button.dart';
import 'package:nb_posx/widgets/custom_appbar.dart';
import 'package:nb_posx/widgets/text_field_widget.dart'; // for making HTTP requests

class CloseShiftManagement extends StatefulWidget {
  
    final RxString selectedView;
  const CloseShiftManagement({super.key, required this.selectedView});

  @override
 CloseShiftManagementState createState() =>CloseShiftManagementState();
}

class CloseShiftManagementState extends State<CloseShiftManagement> {
  List<String> posProfiles = [];
  List<String> paymentMethods = [];
  bool isShiftClose = false;
late TextEditingController  _closingCashCtrl;
double? systemClosingCashBalance;
double? systemClosingDigitalBalance;
 
  late TextEditingController _closingDigitalCtrl;
  @override
  void initState() {
    super.initState();
  _closingCashCtrl = TextEditingController();
  _closingDigitalCtrl = TextEditingController();
    //fetchData();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.fontWhiteColor,
        body:  SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Center(
                child:
                Container(
                  width: 450,
                  padding: paddingXY(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hightSpacer10,
                      openShiftHeadingWidget(),
                      hightSpacer120,
                      hightSpacer20,
                      posCashierSection(),
                      hightSpacer30,
                      paymentMethodsWidget(),
                      hightSpacer30,
                      openShiftBtnWidget(),
                      hightSpacer30
                    ],
                  ),
                ),
              )
            ],
          )),
    );
}

//WIDGETS
Widget openShiftHeadingWidget()=>Center(
  child: Text(
          OPEN_SHIFT.toUpperCase(),
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: LARGE_PLUS_FONT_SIZE,
          ),
        ),
);
//In progress - Pos Cashier 
Widget posCashierSection()=>Container(
    decoration: BoxDecoration(border: Border.all(color: AppColors.getTextandCancelIcon()),
    borderRadius: BorderRadius.circular(6.0)),
    
              child:  DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select POS Profile name'),
                  value: null,
                  items: posProfiles.map((profile) {
                    return DropdownMenuItem<String>(
                      value: profile,
                      child: Text(profile),
                    );
                  }).toList(),
                  onChanged: (value) {
                   
                  },
                ));
                //Dynamic widgets for Payment Method
  Widget paymentMethodsWidget()=>Column(
    children: [
        TextFieldWidget(
              txtCtrl: _closingCashCtrl,
              hintText: 'Enter Opening Cash Balance',
              boxDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              verticalContentPadding: 16,
              password: false, // Not a password field
            ),
            hightSpacer30,
        TextFieldWidget(
              txtCtrl: _closingDigitalCtrl,
              hintText: 'Enter Opening Digital Balance',
              boxDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              verticalContentPadding: 16,
              password: false, // Not a password field
            ),
        
    ],
  );

// WIDGETS- BUTTON
  Widget openShiftBtnWidget()=> ButtonWidget(
          colorTxt:AppColors.fontWhiteColor,
          isMarginRequired: false,
          width: 600,
          onPressed: () async {
            setState(() {
              isShiftClose = true;
             });
              widget.selectedView.value = "Order";   
          },
          title: OPEN_SHIFT.toUpperCase(),
          primaryColor: AppColors.getPrimary(),
          // width: MediaQuery.of(context).size.width - 150,
          height: 60,
          fontSize: LARGE_FONT_SIZE,
  );
}