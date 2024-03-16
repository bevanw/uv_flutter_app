import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/niwa/models/skye_types.dart';
import '../providers/api_providers.dart';
import '../routes.dart';
import '../widgets/permission_icon.dart';
import 'tabs/uv_index_view.dart';
import 'tabs/uv_forecast_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeView();
}

class _HomeView extends ConsumerState<HomeView> {
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
        title: const Text('ultraviolet radiation'),
        centerTitle: true,
        leading: const PermissionIcon(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_currentPageIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: _setIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            label: 'Index',
          ),
          NavigationDestination(
            icon: Icon(Icons.sunny_snowing),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}
