import 'dart:developer';

import '../../../../constants/app_constants.dart';
import '../../../service/sales_history/api/get_sales_history.dart';

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

import 'sales_data_item.dart';

class SalesHistory extends StatefulWidget {
  static int pageSize = 1;
  const SalesHistory({Key? key}) : super(key: key);

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  bool isUserOnline = false;
  late int pageKey;

  //Offline data list
  List<SaleOrder> orderFromLocalDB = [];
  List<SaleOrder> offlineOrders = [];

  String searchTerm = "";

  late TextEditingController _searchsalesController;
  // late PagingController<int, SaleOrder> _pagingController;
  late ScrollController _scrollCtrl;
  bool isLoading = false;

  //Online data List
  List<SaleOrder> salesOrders = [];

  @override
  void initState() {
    //Adding listener for pagination
    _searchsalesController = TextEditingController();
    // _pagingController = PagingController(firstPageKey: 1);
    _scrollCtrl = ScrollController();
    pageKey = 1;
    _getOrdersToShow();

    super.initState();
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    _searchsalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ui screen
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomAppbar(title: SALES_HISTORY_TXT),
            hightSpacer10,
            searchBarWidget(),
            hightSpacer10,
            isUserOnline
                ? _showUserOnlineData(context)
                : _showLocalDBData(context),
          ],
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
      // _pagingController.appendPage(salesOrders, 1);
      pageKey = 1;
      _fetchsalesData();
    }

    if (searchText.trim().length > 2) {
      SalesHistory.pageSize = 1;
      salesOrders.clear();
      _fetchsalesData();
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
  Future<void> _fetchsalesData() async {
    int page = pageKey;
    try {
      //Sales Details api call
      CommanResponse commanResponse = await GetSalesHistory()
          .getSalesHistory(page, _searchsalesController.text.trim());

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
          pageKey = page + 1;

          setState(() {});
        }
      } else if (commanResponse.status! == false &&
          commanResponse.apiStatus == ApiStatus.NO_DATA_AVAILABLE) {
        salesOrders.clear();
        setState(() {});
      }

      //If internet connection is not available
      else if (commanResponse.status! == false &&
          commanResponse.apiStatus == ApiStatus.NO_INTERNET) {
        //Fetch all the orders from db and display it in UI.
        await getSales();
      }
    } catch (error) {
      log('Exception caught :: $error');
      setState(() {});
    }
  }

  void _getOrdersToShow() async {
    isUserOnline = await Helper.isNetworkAvailable();
    if (isUserOnline) {
      //Fetch the offline & not synced orders from db and display it in UI.
      // _pagingController.addPageRequestListener((pageKey) {
      //   print("PAGEKEY: $pageKey");
      //   _fetchsalesData(pageKey);
      // });
      _fetchsalesData();
      _scrollCtrl.addListener(() {
        // print("PAGEKEY: $pageKey");
        // print("PIXELS: ${_scrollCtrl.position.pixels}");
        // print("EXTENT: ${_scrollCtrl.position.maxScrollExtent}");

        if (_scrollCtrl.position.pixels ==
            _scrollCtrl.position.maxScrollExtent) {
          _fetchsalesData();
        }
      });
      await getOfflineOrdersFromDb();
    } else {
      await getSales();
    }
  }

  Widget _showLocalDBData(BuildContext context) {
    return offlineOrders.isEmpty
        ? Center(
            child: Text(
              NO_ORDERS_FOUND_MSG,
              style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            primary: true,
            itemCount: offlineOrders.length,
            itemBuilder: (context, position) {
              return SalesDataItem(
                saleOrder: offlineOrders[position],
              );
            });
  }

  Widget _showUserOnlineData(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          _buildDataList(),
          _loader(),
        ],
      ),
    );
    // return RefreshIndicator(
    //   onRefresh: () => Future.sync(
    //     () => _pagingController.refresh(),
    //   ),
    //   child: PagedListView<int, SaleOrder>(
    //     primary: false,
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     pagingController: _pagingController,
    //     builderDelegate: PagedChildBuilderDelegate<SaleOrder>(
    //         noItemsFoundIndicatorBuilder: (context) {
    //       return Center(
    //         child: Text(
    //           NO_ORDERS_FOUND_MSG,
    //           style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
    //         ),
    //       );
    //     }, itemBuilder: (context, item, position) {
    //       return SalesDataItem(saleOrder: item);
    //     }),
    //   ),
    // );
  }

  /// search bar widget at top
  Widget searchBarWidget() => Padding(
      padding: horizontalSpace(),
      child: SearchWidget(
        searchHint: SEARCH_HINT_TXT,
        searchTextController: _searchsalesController,
        onTextChanged: (text) {
          filterSalesData(text);
        },
        onSubmit: (text) {
          filterSalesData(text);
        },
      ));

  Widget _loader() {
    return isLoading
        ? const Align(
            alignment: FractionalOffset.bottomCenter,
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Center(child: CircularProgressIndicator())),
            ),
          )
        : const SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget _buildDataList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        // primary: true,
        // padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        controller: _scrollCtrl,
        itemCount: salesOrders.length,
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          return SalesDataItem(saleOrder: salesOrders[i]);
        });
  }
}
