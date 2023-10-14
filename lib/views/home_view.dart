import 'package:flutter/material.dart';

import 'home_tabs/uv_index_view.dart';
import 'home_tabs/uv_forecast_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeView();
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
    UVForecastTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UV'),
      ),
      body: Center(
        child: _pages.elementAt(_currentPageIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: _setIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_filled),
            label: 'UV Index',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: 'UV Graphs',
          ),
        ],
      ),
    );
  }
}
