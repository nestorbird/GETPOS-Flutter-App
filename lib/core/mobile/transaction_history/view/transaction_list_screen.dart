import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_constants.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/main_drawer.dart';
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
    if (_isBottom) context.read<TransactionBloc>().add(TransactionFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(
        menuItem: Helper.getMenuItemList(context),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomAppbar(title: SALES_HISTORY_TXT),
            hightSpacer10,
            Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  searchHint: SEARCH_HINT_TXT,
                  searchTextController: _searchTransactionCtrl,
                  onTextChanged: (text) {
                    context
                        .read<TransactionBloc>()
                        .add(TransactionSearched(text));
                  },
                  onSubmit: (text) {
                    context
                        .read<TransactionBloc>()
                        .add(TransactionSearched(text));
                  },
                )),
            hightSpacer10,
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
                      child: Text("no orders"),
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
      ),
    );
  }
}
