import 'package:flutter/material.dart';

class TabBarScrollView extends StatefulWidget {
  @override
  _TabBarScrollViewState createState() => _TabBarScrollViewState();
}

class _TabBarScrollViewState extends State<TabBarScrollView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double height = MediaQuery.of(context).size.height * 0.7; // Adjust threshold

      if (offset >= height * 2) {
        _tabController.animateTo(2);
      } else if (offset >= height) {
        _tabController.animateTo(1);
      } else {
        _tabController.animateTo(0);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scrollable TabBar"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Tab 1"),
            Tab(text: "Tab 2"),
            Tab(text: "Tab 3"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildTabContent("Tab 1 Content", Colors.red),
            _buildTabContent("Tab 2 Content", Colors.green),
            _buildTabContent("Tab 3 Content", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String text, Color color) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Adjust content height
      width: double.infinity,
      color: color.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
