import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../bloc/transaction_bloc.dart';
import 'transaction_list_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionBloc(httpClient: http.Client())..add(TransactionFetched()),
      child: const TransactionListScreen(),
    );
  }
}
