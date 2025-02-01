import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_offer_model.dart';

class RestaurantOfferService {
  static const String baseUrl =
      "https://demo-api.devdata.top/api/RestaurantInfo/GetRestaurantOffer";

  Future<RestaurantOfferModel?> fetchRestaurantOffers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return RestaurantOfferModel.fromJson(json.decode(response.body));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }
}
