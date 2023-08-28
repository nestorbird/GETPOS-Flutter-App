import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/core/mobile/parked_orders/ui/orderlist_screen.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../../constants/app_constants.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/search_widget.dart';
import '../bloc/transaction_bloc.dart';
import 'widgets/bottomloader.dart';
import 'widgets/transaction_item.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final _scrollController = ScrollController();
  late TextEditingController _searchTransactionCtrl;

  @override
  void initState() {
    super.initState();
    _searchTransactionCtrl = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTransactionCtrl.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      if (_searchTransactionCtrl.text.isEmpty) {
        context.read<TransactionBloc>().add(TransactionFetched());
      } else {
        context
            .read<TransactionBloc>()
            .add(TransactionSearched(_searchTransactionCtrl.text, false));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll <= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAppbar(title: SALES_HISTORY_TXT, hideSidemenu: true),
          hightSpacer10,
          Padding(
              padding: horizontalSpace(),
              child: SearchWidget(
                searchHint: SEARCH_HINT_TXT,
                searchTextController: _searchTransactionCtrl,
              keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(12)],
             
                onTextChanged: (text) {
                  if (text.isEmpty) {
                    context.read<TransactionBloc>().state.orders.clear();
                    context.read<TransactionBloc>().add(TransactionFetched());
                  } else {
                    context
                        .read<TransactionBloc>()
                        .add(TransactionSearched(text, true));
                  }
                },
                onSubmit: (text) {
                  if (text.isEmpty) {
                    context.read<TransactionBloc>().state.orders.clear();
                    context.read<TransactionBloc>().add(TransactionFetched());
                  } else {
                    context
                        .read<TransactionBloc>()
                        .add(TransactionSearched(text, true));
                  }
                },
              )),
          hightSpacer10,
          BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
            switch (state.status) {
              case TransactionStatus.failure:
                return const Center(
                  child: Text("Failed to fetch transactions"),
                );
              case TransactionStatus.success:
                if (state.orders.isEmpty) {
                  return const Center(
                    child: Text("No Orders"),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                      itemCount: state.hasReachedMax
                          ? state.orders.length
                          : state.orders.length + 1,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.orders.length
                            ? const Visibility(
                                visible: false, child: BottomLoader())
                            : TransactionItem(order: state.orders[index]);
                      }),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        decoration: const BoxDecoration(
            color: MAIN_COLOR,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderListScreen()));
            },
            child: Text(
              'Parked Orders',
              style: getTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                  color: WHITE_COLOR),
            )),
      ),
    ));
  }
}
