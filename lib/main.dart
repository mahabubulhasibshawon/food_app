import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_app/constants/app_constants/app_constants.dart';
import 'package:food_app/presentation/draggable_screen.dart';
import 'package:food_app/presentation/restaurant_profile_page.dart';
import 'package:food_app/presentation/restaurant_screen.dart';
import 'package:food_app/presentation/tab_bar_scroll_view.dart';
import 'package:food_app/presentation/test_api_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/resturant_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.urbanistTextTheme()
      ),
      home: RestaurantProfilePage(),
    );
  }
}
