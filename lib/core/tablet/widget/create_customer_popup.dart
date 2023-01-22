import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/text_field_widget.dart';

// ignore: must_be_immutable
class CreateCustomerPopup extends StatefulWidget {
  String phoneNo;
  CreateCustomerPopup({Key? key, required this.phoneNo}) : super(key: key);

  @override
  State<CreateCustomerPopup> createState() => _CreateCustomerPopupState();
}

class _CreateCustomerPopupState extends State<CreateCustomerPopup> {
  late TextEditingController phoneCtrl, emailCtrl, nameCtrl;
  Customer? customer;
  bool customerFound = false;

  @override
  void initState() {
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    emailCtrl = TextEditingController();

    phoneCtrl.text = widget.phoneNo;

    super.initState();
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                CROSS_ICON,
                color: BLACK_COLOR,
                width: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            children: [
              Text(
                "Add Customer",
                style: getTextStyle(
                    fontSize: LARGE_FONT_SIZE,
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR),
              ),
              hightSpacer15,
              Container(
                  width: 400,
                  // height: 100,
                  padding: horizontalSpace(),
                  child: TextFieldWidget(
                    boxDecoration: txtFieldBorderDecoration,
                    txtCtrl: phoneCtrl,
                    hintText: "Enter phone no.",
                    txtColor: DARK_GREY_COLOR,
                  )),
              hightSpacer20,
              Container(
                  width: 400,
                  // height: 100,
                  padding: horizontalSpace(),
                  child: TextFieldWidget(
                    boxDecoration: txtFieldBorderDecoration,
                    txtCtrl: nameCtrl,
                    hintText: "Enter name",
                    txtColor: DARK_GREY_COLOR,
                  )),
              hightSpacer20,
              Container(
                  width: 400,
                  // height: 100,
                  padding: horizontalSpace(),
                  child: TextFieldWidget(
                    boxDecoration: txtFieldBorderDecoration,
                    txtCtrl: emailCtrl,
                    hintText: "Enter email (optional)",
                    txtColor: DARK_GREY_COLOR,
                  )),
              hightSpacer40,
              InkWell(
                onTap: () {
                  customer = Customer(
                    id: emailCtrl.text,
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    phone: phoneCtrl.text,
                    // ward: Ward(id: "01", name: "name"),
                    // profileImage: Uint8List.fromList([]),
                  );
                  if (customer != null) {
                    Get.back(result: customer);
                  }
                },
                child: Container(
                  width: 380,
                  height: 50,
                  decoration: BoxDecoration(
                    color: MAIN_COLOR,
                    // phoneCtrl.text.length == 10 && nameCtrl.text.isNotEmpty
                    //     ? MAIN_COLOR
                    //     : MAIN_COLOR.withOpacity(0.3),
                    // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Add & Create order",
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                          fontSize: LARGE_FONT_SIZE,
                          color: WHITE_COLOR,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
