import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/restaurant_offer_model.dart';
import '../models/resturant_info_model.dart';
import '../services/restaurant_offer_service.dart';
import '../services/resturant_service.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
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
      appBar: AppBar(title: Text("Restaurant Info & Offers")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : restaurantInfo?.data == null
          ? Center(child: Text("No restaurant data available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Info
              CachedNetworkImage(
                imageUrl: restaurantInfo!.data!.profileImageUrl ?? "",
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                restaurantInfo!.data!.name ?? "Unknown",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Rating: ${restaurantInfo!.data!.averageRating} ⭐"),
              Text("Delivery Time: ${restaurantInfo!.data!.averageDeliveryTime}"),
              Text("Min Order: ${restaurantInfo!.data!.currency} ${restaurantInfo!.data!.minOrderAmount}"),
          
              SizedBox(height: 30),
          
              // Restaurant Offers
              Text(
                "Special Offers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              restaurantOffers == null || restaurantOffers!.data == null
                  ? Center(child: Text("No offers available"))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: restaurantOffers!.data!.length,
                itemBuilder: (context, index) {
                  final offer = restaurantOffers!.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Discount: ${offer.discount ?? 'N/A'}",
                              style: TextStyle(fontSize: 16)),
                          Text("Discount Type: ${offer.discountType ?? 'N/A'}",
                              style: TextStyle(fontSize: 16)),
                          Text("Min Order: ${offer.minimumOrderAmount ?? 'N/A'}",
                              style: TextStyle(fontSize: 16)),
                          Text("Delivery Mode: ${offer.deliveryMode ?? 'N/A'}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
