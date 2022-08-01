part of 'transaction_bloc.dart';

enum TransactionStatus { initial, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<Transaction> orders;
  final bool hasReachedMax;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.orders = const <Transaction>[],
    this.hasReachedMax = false,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<Transaction>? orders,
    bool? hasReachedMax,
  }) {
    return TransactionState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'TransactionState(status: $status, orders: $orders, hasReachedMax: $hasReachedMax)';

  @override
  List<Object> get props => [status, orders, hasReachedMax];
}
