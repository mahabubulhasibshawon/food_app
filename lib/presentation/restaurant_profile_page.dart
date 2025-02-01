import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../models/restaurant_offer_model.dart';
import '../models/resturant_info_model.dart';
import '../services/restaurant_offer_service.dart';
import '../services/resturant_service.dart';

class RestaurantProfilePage extends StatefulWidget {
  @override
  State<RestaurantProfilePage> createState() => _RestaurantProfilePageState();
}

class _RestaurantProfilePageState extends State<RestaurantProfilePage> with SingleTickerProviderStateMixin {
  final RestaurantService _restaurantService = RestaurantService();
  final RestaurantOfferService _restaurantOfferService = RestaurantOfferService();

  RestaurantInfoModel? restaurantInfo;
  RestaurantOfferModel? restaurantOffers;

  bool isLoading = true;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<String> categories = ["Popular", "Pizza", "Chicken", "Burger", "Platter"];
  final Map<String, GlobalKey> categoryKeys = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    _tabController = TabController(length: categories.length, vsync: this);

    for (var category in categories) {
      categoryKeys[category] = GlobalKey();
    }

    _scrollController.addListener(() {
      _updateTabSelection();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _updateTabSelection() {
    double scrollPosition = _scrollController.position.pixels;
    double threshold = 100.0; // Adjust this threshold as needed

    for (int i = 0; i < categories.length; i++) {
      final key = categoryKeys[categories[i]];
      if (key != null) {
        final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
          if (position.dy <= scrollPosition + threshold && position.dy + renderBox.size.height > scrollPosition - threshold) {
            if (_tabController.index != i) {
              _tabController.animateTo(i);
            }
            break;
          }
        }
      }
    }
  }

  void _scrollToCategory(int index) {
    final key = categoryKeys[categories[index]];
    if (key != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   leading: Icon(CupertinoIcons.back),
        // ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: Icon(CupertinoIcons.back),
                expandedHeight: 375.0,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    restaurantInfo?.data?.profileImageUrl ?? "", // Handle null safety
                    fit: BoxFit.cover,
                  ),
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  restaurantInfo?.data?.name ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 5),
                                Image.asset('assets/images/bi_info.png')
                              ],
                            ),
                            Column(
                              children: [
                                Text(restaurantInfo?.data?.averageRating ?? "", style: TextStyle(fontSize: 14)),
                                Row(
                                  children: [
                                    Text(restaurantInfo?.data?.totalRating ?? "", style: TextStyle(fontSize: 9, color: Color(0xff90969D))),
                                    Text(' ratings',style: TextStyle(fontSize: 9, color: Color(0xff90969D)) )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/clock.png', height: 12,),
                                Text('Delivery',style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                                Text(restaurantInfo?.data?.averageDeliveryTime ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade400),),
                                Image.asset('assets/images/navigation.png'),
                                Text(restaurantInfo?.data?.distance ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade400),),
                                Text(' away',style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                              ],
                            ),
                            GestureDetector(onTap: () {}, child: Text('Review', style: TextStyle(color: Color(0xffA1045A), fontSize: 12),))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[500],
                      indicator: BoxDecoration(
                        color: Color(0xffA1045A), // Background for selected tab
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      onTap: _scrollToCategory,
                      tabs: categories.map((category) {
                        final bool isSelected = _tabController.index == categories.indexOf(category);

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: isSelected
                              ? null // No border or extra styling for selected tab
                              : BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!, width: 2), // Grey border for unselected tabs
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent, // White background for unselected tabs
                          ),
                          child: Tab(text: category),
                        );
                      }).toList(),
                    )

                ),
              ),
            ];
          },
          body: isLoading ? _buildShimmerLoading() : _buildMenuList(),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(width: 60, height: 60, color: Colors.white),
              title: Container(height: 10, color: Colors.white),
              subtitle: Container(height: 10, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: categories.map((category) {
        return Column(
          key: categoryKeys[category],
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                category,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ...List.generate(5, (index) => _buildMenuItem(category, index))
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(String category, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset('assets/pizza.png', width: 60, fit: BoxFit.cover),
        title: Text("$category Item ${index + 1}"),
        subtitle: Text("Delicious meal with spices and cheese"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("AED 120", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text("AED 150", style: TextStyle(decoration: TextDecoration.lineThrough)),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Tab bar background color
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../models/restaurant_offer_model.dart';
// import '../models/resturant_info_model.dart';
// import '../services/restaurant_offer_service.dart';
// import '../services/resturant_service.dart';
//
// class RestaurantProfilePage extends StatefulWidget {
//   @override
//   State<RestaurantProfilePage> createState() => _RestaurantProfilePageState();
// }
//
// class _RestaurantProfilePageState extends State<RestaurantProfilePage> with SingleTickerProviderStateMixin {
//   final RestaurantService _restaurantService = RestaurantService();
//   final RestaurantOfferService _restaurantOfferService = RestaurantOfferService();
//
//   RestaurantInfoModel? restaurantInfo;
//   RestaurantOfferModel? restaurantOffers;
//
//   bool isLoading = true;
//   late TabController _tabController;
//   final ScrollController _scrollController = ScrollController();
//
//   final List<String> categories = ["Popular", "Pizza", "Chicken", "Burger", "Platter"];
//   final Map<String, GlobalKey> categoryKeys = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//     _tabController = TabController(length: categories.length, vsync: this);
//
//     for (var category in categories) {
//       categoryKeys[category] = GlobalKey();
//     }
//
//     _scrollController.addListener(() {
//       _updateTabSelection();
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _fetchData() async {
//     final info = await _restaurantService.fetchRestaurantInfo();
//     final offers = await _restaurantOfferService.fetchRestaurantOffers();
//
//     setState(() {
//       restaurantInfo = info;
//       restaurantOffers = offers;
//       isLoading = false;
//     });
//   }
//
//   void _updateTabSelection() {
//     for (int i = 0; i < categories.length; i++) {
//       final key = categoryKeys[categories[i]];
//       if (key != null) {
//         final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
//         if (renderBox != null) {
//           final position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
//           if (position.dy > 0 && position.dy < 200) {
//             _tabController.animateTo(i);
//             break;
//           }
//         }
//       }
//     }
//   }
//
//   void _scrollToCategory(int index) {
//     final key = categoryKeys[categories[index]];
//     if (key != null) {
//       Scrollable.ensureVisible(
//         key.currentContext!,
//         duration: Duration(milliseconds: 300),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(CupertinoIcons.back),
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               labelColor: Colors.orange,
//               unselectedLabelColor: Colors.grey[400],
//               indicatorColor: Colors.white,
//               onTap: _scrollToCategory,
//               tabs: categories.map((category) => Tab(text: category)).toList(),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               controller: _scrollController,
//               padding: EdgeInsets.all(16),
//               children: categories.map((category) {
//                 return Column(
//                   key: categoryKeys[category],
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Text(
//                         category,
//                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ...List.generate(5, (index) => _buildMenuItem(category, index))
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(String category, int index) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Image.asset('assets/pizza.png', width: 60, fit: BoxFit.cover),
//         title: Text("$category Item ${index + 1}"),
//         subtitle: Text("Delicious meal with spices and cheese"),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("AED 120", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//             Text("AED 150", style: TextStyle(decoration: TextDecoration.lineThrough)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../models/restaurant_offer_model.dart';
// import '../models/resturant_info_model.dart';
// import '../services/restaurant_offer_service.dart';
// import '../services/resturant_service.dart';
//
// class RestaurantProfilePage extends StatefulWidget {
//   @override
//   State<RestaurantProfilePage> createState() => _RestaurantProfilePageState();
// }
//
// class _RestaurantProfilePageState extends State<RestaurantProfilePage> with SingleTickerProviderStateMixin {
//   final RestaurantService _restaurantService = RestaurantService();
//   final RestaurantOfferService _restaurantOfferService = RestaurantOfferService();
//
//   RestaurantInfoModel? restaurantInfo;
//   RestaurantOfferModel? restaurantOffers;
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//
//
//   void _fetchData() async {
//     final info = await _restaurantService.fetchRestaurantInfo();
//     final offers = await _restaurantOfferService.fetchRestaurantOffers();
//
//     setState(() {
//       restaurantInfo = info;
//       restaurantOffers = offers;
//       isLoading = false;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           leading:Icon(CupertinoIcons.back),
//         ),
//         body: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               pinned: false,
//               automaticallyImplyLeading: false, // Remove the default leading space
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Image.network(
//                   restaurantInfo?.data?.profileImageUrl ?? "", // Handle null safety
//                   fit: BoxFit.cover,
//                 ),
//                 titlePadding: EdgeInsets.zero, // Remove default title padding
//                 title: Container(
//                   width: double.infinity,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
//                     color: Colors.white,
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust as needed
//                   alignment: Alignment.centerLeft, // Align text to the left
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 restaurantInfo?.data?.name ?? "",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black, // Ensure visibility
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(width: 5,),
//                               Image.asset('assets/images/bi_info.png')
//                             ],
//                           ),
//                           Text(restaurantInfo?.data?.averageRating ?? "", style: TextStyle(fontSize: 14),)
//                         ],
//                       ),
//                       Row(children: [
//                         Image.asset('assets/images/clock.png'),
//                         Text('Delivery' ),
//                         Text(restaurantInfo?.data?.averageDeliveryTime ?? '')
//                       ],)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//               // SliverAppBar(
//               //   expandedHeight: 200.0,
//               //   pinned: false,
//               //   flexibleSpace: FlexibleSpaceBar(
//               //     background: Image.network(
//               //       restaurantInfo!.data!.profileImageUrl ?? "", // Replace with network image if needed
//               //       fit: BoxFit.cover,
//               //     ),
//               //     title: Text(restaurantInfo!.data!.name ?? ""),
//               //
//               //   ),
//               // ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _SliverAppBarDelegate(
//                   TabBar(
//                     isScrollable: true,
//                     labelColor: Colors.white,
//                     unselectedLabelColor: Colors.grey[400],
//                     indicatorColor: Colors.white,
//                     tabs: [
//                       Tab(text: "Popular 🔥"),
//                       Tab(text: "Pizza 🍕"),
//                       Tab(text: "Chicken 🍗"),
//                       Tab(text: "Burger 🍔"),
//                       Tab(text: "Platter 🍽️"),
//                     ],
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: TabBarView(
//             children: [
//               MenuListView(category: "Popular"),
//               MenuListView(category: "Pizza"),
//               MenuListView(category: "Chicken"),
//               MenuListView(category: "Burger"),
//               MenuListView(category: "Platter"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//   _SliverAppBarDelegate(this.tabBar);
//
//   @override
//   double get minExtent => tabBar.preferredSize.height;
//   @override
//   double get maxExtent => tabBar.preferredSize.height;
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.deepPurple, // Tab bar background color
//       child: tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }
//
// class MenuListView extends StatelessWidget {
//   final String category;
//   MenuListView({required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: 5, // Example item count
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: ListTile(
//             leading: Image.asset('assets/pizza.jpg', width: 60, fit: BoxFit.cover),
//             title: Text("$category Item ${index + 1}"),
//             subtitle: Text("Delicious meal with spices and cheese"),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("AED 120", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//                 Text("AED 150", style: TextStyle(decoration: TextDecoration.lineThrough)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
