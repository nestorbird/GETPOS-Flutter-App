import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// for json decoding
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/widgets/button.dart';
import 'package:nb_posx/widgets/custom_appbar.dart';
import 'package:nb_posx/widgets/text_field_widget.dart'; // for making HTTP requests

class CloseShiftManagement extends StatefulWidget {
   final bool isCloseShift;
    final RxString selectedView;
  const CloseShiftManagement({super.key,this.isCloseShift = false, required this.selectedView});

  @override
 CloseShiftManagementState createState() =>CloseShiftManagementState();
}

class CloseShiftManagementState extends State<CloseShiftManagement> {
  List<String> posProfiles = [];
  List<String> paymentMethods = [];
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
    return 
    // Scaffold(
     
    //   appBar: AppBar(
    //   //  leadingWidth: ,
    //     title:  Center(
    //       child: Text(
    //         "Close Shift",
    //         style: getTextStyle(
    //           // color: MAIN_COLOR,
    //           fontWeight: FontWeight.bold,
    //           fontSize: 26.0,
        
    //       ),
    //     ),
        
    //   ),
    //   ),
    //  body:
   // body: 
      Scaffold(
        
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.fontWhiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
            children: [
              // hightSpacer40,
            const CustomAppbar(title: CLOSE_SHIFT, hideSidemenu: true, showBackBtn: true,),
            hightSpacer100,
             Stack(
              children: [
           // TODO:: Check Internet availablity through network manager    
                Center(
                  child: Container(
                    width: 550,
                    padding: paddingXY(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
               
                hightSpacer100,
                TextFieldWidget(
              txtCtrl: _closingCashCtrl,
              hintText: 'Enter Closing Cash Balance',
              boxDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              verticalContentPadding: 10,
              password: false, // Not a password field
            ),
           hightSpacer20,
Text(
              'System Closing Cash Balance: ${systemClosingCashBalance ?? "Loading..."}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
             hightSpacer20,
            TextFieldWidget(
              txtCtrl: _closingDigitalCtrl,
              hintText: 'Enter Closing Digital Balance',
              boxDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              verticalContentPadding: 10,
              password: false, // Not a password field
            ),
                  hightSpacer20,
                  Text(
              'System Closing Digital Balance: ${systemClosingDigitalBalance ?? "Loading..."}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
             hightSpacer20,
                // Dynamic payment method fields
                for (var method in paymentMethods)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Enter $method Amount'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                    },
                  ),
                       hightSpacer50,
                   closeShiftWidget() 
              ],
            ),
          ),
                ),
              ],
            )
            ],
          ),
        ),
        ),
    );
        //);
  }
  //Open Shift through custom Open Shift buttom
             Widget closeShiftWidget() => Center(
               child: Container(
                       margin: const EdgeInsets.only(bottom: 20.0),
                       width: 800,
                  
                       child: ButtonWidget(
                       
                         onPressed: () async {
                          // await fetchData(_emailCtrl.text, _passCtrl.text, url);
                          
                         },
                         title: "Close Shift",
                         primaryColor: AppColors.getPrimary(),
                         // width: MediaQuery.of(context).size.width - 150,
                         height: 60,
                         fontSize: LARGE_PLUS_FONT_SIZE,
                       ),
                     ),
             );

}
