import 'package:flutter/material.dart';

import '../models/restaurant_offer_model.dart';
import '../models/resturant_info_model.dart';
import '../services/restaurant_offer_service.dart';
import '../services/resturant_service.dart';

class TestApiScreen extends StatefulWidget {
  const TestApiScreen({super.key});

  @override
  State<TestApiScreen> createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  final RestaurantOfferService _restaurantOfferService = RestaurantOfferService();

  RestaurantInfoModel? restaurantInfo;
  RestaurantOfferModel? restaurantOffers;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final info = await _restaurantService.fetchRestaurantInfo();
    final offers = await _restaurantOfferService.fetchRestaurantOffers();

    setState(() {
      restaurantInfo = info;
      restaurantOffers = offers;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.maxFinite,
            decoration: BoxDecoration(
            ),
            child: Image.network(restaurantInfo!.data!.profileImageUrl ?? ""),
          )
        ],
      ),
    );
  }
}
