import 'package:flutter/material.dart';

import 'home_tabs/uv_index_chart.dart';
import 'home_tabs/uv_index.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  int _currentPageIndex = 0;

  void _setIndex(int i) {
    setState(() {
      _currentPageIndex = i;
    });
  }

  static const List<Widget> _pages = <Widget>[
    UVIndexTab(),
    UVIndexChartTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UV Index'),
      ),
      body: Center(
        child: _pages.elementAt(_currentPageIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _setIndex,
        destinations: const [
          NavigationDestination(
            key: Key("UV Index"),
            icon: Icon(Icons.home_filled),
            label: 'UV Index',
          ),
          NavigationDestination(
            key: Key("UV Graphs"),
            icon: Icon(Icons.account_balance),
            label: 'UV Graphs',
          ),
        ],
      ),
    );
  }
}