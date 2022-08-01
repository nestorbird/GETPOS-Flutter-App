import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../mobile/transaction_history/bloc/transaction_bloc.dart';
import 'transaction_landscape.dart';

class TransactionScreenLandscape extends StatelessWidget {
  final RxString selectedView;
  const TransactionScreenLandscape({Key? key, required this.selectedView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionBloc(httpClient: http.Client())..add(TransactionFetched()),
      child: TransactionLandscape(
        selectedView: selectedView,
      ),
    );
  }
}
