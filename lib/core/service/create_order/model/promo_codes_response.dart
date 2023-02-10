class PromoCodesResponse {
  Message? message;

  PromoCodesResponse({this.message});

  PromoCodesResponse.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? successKey;
  String? message;
  List<CouponCode>? couponCode;

  Message({this.successKey, this.message, this.couponCode});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    if (json['coupon_code'] != null) {
      couponCode = <CouponCode>[];
      json['coupon_code'].forEach((v) {
        couponCode!.add(CouponCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    if (couponCode != null) {
      data['coupon_code'] = couponCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponCode {
  String? name;
  String? couponCode;
  String? pricingRule;
  int? maximumUse;
  int? used;
  String? description;
  String? validFrom;
  String? validUpto;
  String? applyOn;
  String? priceOrProductDiscount;
  int? minQty;
  int? maxQty;
  int? minAmt;
  int? maxAmt;
  String? rateOrDiscount;
  String? applyDiscountOn;
  int? discountAmount;
  int? rate;
  int? discountPercentage;

  CouponCode(
      {this.name,
      this.couponCode,
      this.pricingRule,
      this.maximumUse,
      this.used,
      this.description,
      this.validFrom,
      this.validUpto,
      this.applyOn,
      this.priceOrProductDiscount,
      this.minQty,
      this.maxQty,
      this.minAmt,
      this.maxAmt,
      this.rateOrDiscount,
      this.applyDiscountOn,
      this.discountAmount,
      this.rate,
      this.discountPercentage});

  CouponCode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    couponCode = json['coupon_code'];
    pricingRule = json['pricing_rule'];
    maximumUse = json['maximum_use'];
    used = json['used'];
    description = json['description'];
    validFrom = json['valid_from'];
    validUpto = json['valid_upto'];
    applyOn = json['apply_on'];
    priceOrProductDiscount = json['price_or_product_discount'];
    minQty = json['min_qty'];
    maxQty = json['max_qty'];
    minAmt = json['min_amt'];
    maxAmt = json['max_amt'];
    rateOrDiscount = json['rate_or_discount'];
    applyDiscountOn = json['apply_discount_on'];
    discountAmount = json['discount_amount'];
    rate = json['rate'];
    discountPercentage = json['discount_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['coupon_code'] = couponCode;
    data['pricing_rule'] = pricingRule;
    data['maximum_use'] = maximumUse;
    data['used'] = used;
    data['description'] = description;
    data['valid_from'] = validFrom;
    data['valid_upto'] = validUpto;
    data['apply_on'] = applyOn;
    data['price_or_product_discount'] = priceOrProductDiscount;
    data['min_qty'] = minQty;
    data['max_qty'] = maxQty;
    data['min_amt'] = minAmt;
    data['max_amt'] = maxAmt;
    data['rate_or_discount'] = rateOrDiscount;
    data['apply_discount_on'] = applyDiscountOn;
    data['discount_amount'] = discountAmount;
    data['rate'] = rate;
    data['discount_percentage'] = discountPercentage;
    return data;
  }
}

