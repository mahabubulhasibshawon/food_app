import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/resturant_info_model.dart';

class RestaurantService {
  static const String baseUrl = "https://demo-api.devdata.top/api/RestaurantInfo/GetRestaurantInfo";

  Future<RestaurantInfoModel?> fetchRestaurantInfo() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RestaurantInfoModel.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }
}
