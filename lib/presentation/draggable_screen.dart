

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/app_constants/app_constants.dart';

class DraggableScreen extends StatefulWidget {
  @override
  _DraggableScreenState createState() => _DraggableScreenState();
}

class _DraggableScreenState extends State<DraggableScreen> {
  bool _showHeader = true;
  bool _isAtTop = false; // Flag to check if the header is at the top
  ScrollController _scrollController = ScrollController();
  bool _isSheetExpanded = false; // Flag to check if the sheet is fully expanded

  @override
  void initState() {
    super.initState();

    // Detect scrolling direction and position
    _scrollController.addListener(() {
      // Check if the sheet is fully expanded and scrolled to the top
      if (_scrollController.offset == 0 && _isSheetExpanded) {
        setState(() {
          _isAtTop = true; // Header is at the top
        });
      } else {
        setState(() {
          _isAtTop = false; // Header is not at the top
        });
      }

      // Detect scrolling direction to show/hide header
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showHeader) {
          setState(() {
            _showHeader = false; // Hide the header when scrolling down
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showHeader) {
          setState(() {
            _showHeader = true; // Show the header when scrolling up
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Top Part - Background Image
          Positioned.fill(
            child: Image.network(
              AppConstants.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          /// DraggableScrollableSheet (Bottom Part)
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              // Assign the scroll controller passed by DraggableScrollableSheet
              _scrollController = scrollController;

              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  // Check if the sheet is fully expanded
                  if (notification.extent == notification.maxExtent) {
                    setState(() {
                      _isSheetExpanded = true;
                    });
                  } else {
                    setState(() {
                      _isSheetExpanded = false;
                    });
                  }
                  return true;
                },
                child: Column(
                  children: [
                    /// Floating Header (Above DraggableScrollableSheet, Hides on Scroll Down)
                    Visibility(
                      visible: _showHeader,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _showHeader ? 1.0 : 0.0,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _isAtTop ? "Fixed Top" : "Floating Header", // Change text based on scroll position
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    /// Draggable Container
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              /// Drag Handle
                              Container(
                                width: 50,
                                height: 5,
                                margin: EdgeInsets.only(top: 10, bottom: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Scroll to hide/show the floating header!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text("Item $index"),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}