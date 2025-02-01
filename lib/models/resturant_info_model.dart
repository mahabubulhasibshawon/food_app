class RestaurantInfoModel {
  int? status;
  String? message;
  Data? data;

  RestaurantInfoModel({this.status, this.message, this.data});

  factory RestaurantInfoModel.fromJson(Map<String, dynamic> json) {
    return RestaurantInfoModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  String? name;
  String? profileImageUrl;
  String? averageDeliveryTime;
  String? averageRating;
  String? totalRating;
  int? minOrderAmount;
  String? currency;
  String? deliveryMode;
  String? distance;

  Data({
    this.name,
    this.profileImageUrl,
    this.averageDeliveryTime,
    this.averageRating,
    this.totalRating,
    this.minOrderAmount,
    this.currency,
    this.deliveryMode,
    this.distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['Name'],
      profileImageUrl: json['ProfileImageUrl'],
      averageDeliveryTime: json['AverageDeliveryTime'],
      averageRating: json['AverageRating'],
      totalRating: json['TotalRating'],
      minOrderAmount: json['MinOrderAmount'],
      currency: json['Currency'],
      deliveryMode: json['DeliveryMode'],
      distance: json['Distance'],
    );
  }
}
