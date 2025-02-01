class RestaurantOfferModel {
  int? status;
  String? message;
  List<Data>? data;

  RestaurantOfferModel({this.status, this.message, this.data});

  RestaurantOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? discount;
  String? discountType;
  int? minimumOrderAmount;
  String? deliveryMode;

  Data(
      {this.discount,
        this.discountType,
        this.minimumOrderAmount,
        this.deliveryMode});

  Data.fromJson(Map<String, dynamic> json) {
    discount = json['Discount'];
    discountType = json['DiscountType'];
    minimumOrderAmount = json['MinimumOrderAmount'];
    deliveryMode = json['DeliveryMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Discount'] = this.discount;
    data['DiscountType'] = this.discountType;
    data['MinimumOrderAmount'] = this.minimumOrderAmount;
    data['DeliveryMode'] = this.deliveryMode;
    return data;
  }
}
