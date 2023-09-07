import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../widgets/shimmer_widget.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../../utils/helper.dart';
import '../../mobile/transaction_history/bloc/transaction_bloc.dart';
import '../../mobile/transaction_history/view/widgets/bottomloader.dart';
import '../../mobile/transaction_history/view/widgets/transaction_item_landscape.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/title_search_bar.dart';

class TransactionLandscape extends StatefulWidget {
  final RxString selectedView;

  const TransactionLandscape({Key? key, required this.selectedView})
      : super(key: key);

  @override
  State<TransactionLandscape> createState() => _TransactionLandscapeState();
}

class _TransactionLandscapeState extends State<TransactionLandscape> {
  final _scrollController = ScrollController();
  late TextEditingController searchCtrl;

  // List<Transaction> orders = [];
  // List<Transaction> ordersToShow = [];
  // bool isCustomersFound = true;

  @override
  void initState() {   verify();
    super.initState();
    searchCtrl = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchCtrl.dispose();   _focusNode.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // if (_isBottom) context.read<TransactionBloc>().add(TransactionFetched());
    if (_isBottom) {
      if (searchCtrl.text.isEmpty) {
        context.read<TransactionBloc>().add(TransactionFetched());
      } else {
        context
            .read<TransactionBloc>()
            .add(TransactionSearched(searchCtrl.text, false));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }
  final FocusNode _focusNode = FocusNode();


  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector (onTap: _handleTap,child: Column(
      children: [
        hightSpacer10,
          TitleAndSearchBar(focusNode: _focusNode,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          parkedOrderVisible: true,
          title: "Orders History",
          onSubmit: (text) {
            // context
            //     .read<TransactionBloc>()
            //     .add(TransactionSearched(text, true));
            if (text.isEmpty) {
              context.read<TransactionBloc>().state.orders.clear();
              context.read<TransactionBloc>().add(TransactionFetched());
            } else {
              context
                  .read<TransactionBloc>()
                  .add(TransactionSearched(text, true));
            }
          },
          onTextChanged: (text) {
            //context.read<TransactionBloc>().add(TransactionSearched(val, true));
            if (text.isEmpty) {
              context.read<TransactionBloc>().state.orders.clear();
              context.read<TransactionBloc>().add(TransactionFetched());
            } else {
              context
                  .read<TransactionBloc>()
                  .add(TransactionSearched(text, true));
            }
          },
          parkOrderClicked: () {
            widget.selectedView.value = "Parked Order";

            // widget.selectedTab = "";
            debugPrint("parked order clicked");
          },
          searchCtrl: searchCtrl,
          searchHint: "Enter customer mobile number",
        ),
        hightSpacer20,
        BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          switch (state.status) {
            case TransactionStatus.failure:
              return const Center(
                child: Text("Failed to fetch Transactions"),
              );
            case TransactionStatus.success:
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text("No data available..."),
                );
              }
              return Expanded(
                child: transactionsGrid(state),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }),
      ],
    ));
  }

  Widget transactionsGrid(TransactionState state) {
    debugPrint("OrderLENGTH:${state.orders.length} ");

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: GridView.builder(
        controller: _scrollController,
        itemCount:
            state.hasReachedMax ? state.orders.length : state.orders.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: Get.height > Get.width ? 3 : 4.8,
          // childAspectRatio: 4.8,
        ),
        shrinkWrap: true,
        primary: false,
        physics: const ScrollPhysics(),
        itemBuilder: (context, position) {
          if (state.orders.isEmpty) {
            return const ShimmerWidget();
          } else {
            return position >= state.orders.length && !state.hasReachedMax
                ? const Center(child: BottomLoader())
                : TransactionItemLandscape(order: state.orders[position]);
          }
        },
      ),
    );
  }
  verify() async {
    CommanResponse res = await VerificationUrl.checkAppStatus();
    if (res.message == true) {
    } else {
      Helper.showPopup(context, "Please update your app to latest version",
          barrierDismissible: true);
    }
  }
}
