part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionFetched extends TransactionEvent {}

class TransactionSearched extends TransactionEvent {
  final String text;

  TransactionSearched(this.text);
  @override
  List<Object> get props => [text];
}
