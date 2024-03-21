import 'package:nb_posx/database/models/balance_details.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';

class CreateOpeningShiftResponse {
  final Message? message;

  CreateOpeningShiftResponse({this.message});

  factory CreateOpeningShiftResponse.fromJson(Map<String, dynamic> json) {
  return CreateOpeningShiftResponse(
    message: json['message'] != null
        ? Message.fromJson(json['message'] as Map<String, dynamic>)
        : null,
  );
}
}

class Message {
 
  final CreateOpeningShiftDb? createOpeningShift;
  final List<BalanceDetail>?  openingShiftbalance;
  // final List<PaymentType>? paymentTypes;

  Message({this.createOpeningShift, this.openingShiftbalance});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      createOpeningShift: json['pos_opening_shift'] != null
        ?CreateOpeningShiftDb .fromJson(json['pos_opening_shift'] as Map<String, dynamic>)
        : null,
       openingShiftbalance: (json['balance_details'] as List<dynamic>?)
        ?.map((detail) => BalanceDetail.fromJson(detail as Map<String, dynamic>))
        .toList(),
      
    );
  }
}