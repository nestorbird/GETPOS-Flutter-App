import 'dart:developer';

import '../../../../constants/app_constants.dart';

import '../../../../database/db_utils/db_sale_order.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../network/api_helper/api_status.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../service/sales_history/api/get_sales_history.dart';
import 'sales_data_item.dart';

class SalesHistory extends StatefulWidget {
  static int pageSize = 1;
  const SalesHistory({Key? key}) : super(key: key);

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  bool isUserOnline = false;

  //Offline data list
  List<SaleOrder> orderFromLocalDB = [];
  List<SaleOrder> offlineOrders = [];

  String searchTerm = "";

  late TextEditingController searchsalesController;
  late PagingController<int, SaleOrder> _pagingController;

  bool isLoading = false;

  //Online data List
  List<SaleOrder> salesOrders = [];

  @override
  void initState() {
    //Adding listener for pagination
    searchsalesController = TextEditingController();
    _pagingController = PagingController(firstPageKey: 1);
    _getOrdersToShow();

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    searchsalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomAppbar(title: SALES_HISTORY_TXT),
              hightSpacer10,
              Padding(
                  padding: horizontalSpace(),
                  child: SearchWidget(
                    searchHint: SEARCH_HINT_TXT,
                    searchTextController: searchsalesController,
                    onTextChanged: (text) {
                      filterSalesData(text);
                      // else
                      //   getSales();
                    },
                    onSubmit: (text) {
                      filterSalesData(text);
                      // else
                      //   getSales();
                    },
                  )),
              hightSpacer10,
              Visibility(
                visible: orderFromLocalDB.isNotEmpty,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: offlineOrders.length,
                    itemBuilder: (context, position) {
                      return SalesDataItem(
                        saleOrder: offlineOrders[position],
                      );
                    }),
              ),
              !isUserOnline
                  ? Container()
                  : RefreshIndicator(
                      onRefresh: () => Future.sync(
                        () => _pagingController.refresh(),
                      ),
                      child: PagedListView<int, SaleOrder>(
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<SaleOrder>(
                            noItemsFoundIndicatorBuilder: (context) {
                          return Center(
                            child: Text(
                              NO_ORDERS_FOUND_MSG,
                              style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
                            ),
                          );
                        }, itemBuilder: (context, item, position) {
                          return SalesDataItem(saleOrder: item);
                        }),
                      ),
                    ),
            ],
            //),
          ),
        ),
      ),
    );
  }

  ///Function to fetch all the orders from db.
  Future<void> getSales() async {
    orderFromLocalDB = await DbSaleOrder().getOrders();

    offlineOrders = orderFromLocalDB.reversed.toList();

    setState(() {});
  }

  ///Function to filter the orders as per the search keyword.
  void filterSalesData(String searchText) {
    offlineOrders = orderFromLocalDB
        .where((element) =>
            element.id.toLowerCase().contains(searchText) ||
            element.customer.name.toLowerCase().contains(searchText) ||
            element.customer.phone.toLowerCase().contains(searchText))
        .toList();
    offlineOrders = offlineOrders.reversed.toList();

    if (searchText.trim().isEmpty) {
      offlineOrders = orderFromLocalDB.reversed.toList();
      _pagingController.refresh();
    }

    if (searchText.trim().length > 2) {
      SalesHistory.pageSize = 1;
      salesOrders = [];
      _pagingController.refresh();
    }

    setState(() {});
  }

  ///Function to fetch the offline orders from db, which is not synced.
  Future<void> getOfflineOrdersFromDb() async {
    orderFromLocalDB = await DbSaleOrder().getOfflineOrders();
    offlineOrders = orderFromLocalDB.reversed.toList();

    setState(() {});
  }

  ///Function to fetch the sales data from server in page form.
  Future<void> _fetchsalesData(int page) async {
    try {
      //Sales Details api call
      CommanResponse commanResponse = await GetSalesHistory()
          .getSalesHistory(page, searchsalesController.text.trim());

      //If success response from api means internet is also available
      if (commanResponse.status!) {
        //Casting the custom response into actual response
        var salesData = commanResponse.message as List<SaleOrder>;

        //Adding all the sales data from api into the online sales details list.
        salesOrders.addAll(salesData);

        //Check whether the page is last or not
        bool isLastPage = salesOrders.length >= SalesHistory.pageSize;

        //If page is not last then increment the key (page value) by 1.
        if (!isLastPage) {
          //Incrementing the page by 1.
          int nextPageKey = page + 1;

          //Appending the fetched sales data into paging controller along with next page value.
          _pagingController.appendPage(salesData, nextPageKey);
        }

        //If the page is last
        else {
          //Appending the last page in paging controller
          _pagingController.appendLastPage(salesData);
        }
      } else if (commanResponse.status! == false &&
          commanResponse.apiStatus == ApiStatus.NO_DATA_AVAILABLE) {
        List<SaleOrder> salesData = [];
        // TODO::: handle data in case of search if no matching data found
        _pagingController.appendLastPage(salesData);
      }

      //If internet connection is not available
      else if (commanResponse.status! == false &&
          commanResponse.apiStatus == ApiStatus.NO_INTERNET) {
        //Fetch all the orders from db and display it in UI.
        await getSales();
      }
    } catch (error) {
      log('Exception caught :: $error');
      _pagingController.error = error;
    }
  }

  void _getOrdersToShow() async {
    isUserOnline = await Helper.isNetworkAvailable();
    if (isUserOnline) {
      //Fetch the offline & not synced orders from db and display it in UI.
      _pagingController.addPageRequestListener((pageKey) {
        // print("PAGEKEY: $pageKey");
        _fetchsalesData(pageKey);
      });
      await getOfflineOrdersFromDb();
    } else {
      await getSales();
    }
  }
}
