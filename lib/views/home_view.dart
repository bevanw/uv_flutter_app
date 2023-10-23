import 'package:flutter/material.dart';
import 'package:uv_flutter_app/providers/api_providers.dart';

import '../apis/niwa/models/skye_types.dart';
import 'home_tabs/uv_index_view.dart';
import 'home_tabs/uv_forecast_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  int _currentPageIndex = 0;
  late UVParameters uvParameters;

  @override
  void initState() {
    super.initState();
    uvParameters = UVParameters(latitude: -35, longitude: 175, skyTypes: SkyTypes.clear);
  }

  void _setIndex(int i) {
    setState(() {
      _currentPageIndex = i;
    });
  }

  List<Widget> get _pages {
    return [
      UVIndexTab(uvParameters: uvParameters),
      UVForecastTab(uvParameters: uvParameters),
    ];
  }

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
            label: 'Index',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}
