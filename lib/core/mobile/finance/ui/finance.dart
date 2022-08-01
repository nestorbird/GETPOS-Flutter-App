import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/helper.dart';
import '../../../../../widgets/main_drawer.dart';
import '../../../service/finance/api/get_updated_account_details.dart';

class Finance extends StatefulWidget {
  const Finance({Key? key}) : super(key: key);

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  late String cashCollected;

  @override
  void initState() {
    super.initState();
    cashCollected = "00.00";
    _initView();
  }

  _initView() async {
    if (await Helper.isNetworkAvailable()) {
      // print("INTERNET AVAILABLE");
      Helper.showLoaderDialog(context);
      await UpdatedHubManagerDetails().getUpdatedAccountDetails();
      if (!mounted) return;
      Helper.hideLoader(context);
      _getcashCollected();
    } else {
      // print("INTERNET NOT AVAILABLE");
      _getcashCollected();
    }
  }

  _getcashCollected() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    cashCollected = Helper().formatCurrency(manager.cashBalance);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(
        menuItem: Helper.getMenuItemList(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(title: FINANCE_TITLE),
              hightSpacer30,
              Padding(
                padding: const EdgeInsets.only(
                    left: FINANCE_PADDING_LEFT, bottom: FINANCE_PADDING_BOTTOM),
                child: Row(
                  children: [
                    Text(
                      "$APP_CURRENCY $cashCollected",
                      style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          color: MAIN_COLOR),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: leftSpace(),
                child: Row(
                  children: [
                    Text(
                      CASH_BALANCE_TXT,
                      style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          color: DARK_GREY_COLOR),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
