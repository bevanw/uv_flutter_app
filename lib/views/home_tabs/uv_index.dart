import 'package:flutter/material.dart';

import '../../apis/models/uv_forecast.dart';
import '../../apis/uv_forecast_service.dart';

class UVIndexTab extends StatefulWidget {
  const UVIndexTab({Key? key}) : super(key: key);

  @override
  State<UVIndexTab> createState() => _UVIndexTab();
}

class _UVIndexTab extends State<UVIndexTab> {
  late Future<UVForecast> futureUvIndex;

  @override
  void initState() {
    super.initState();
    futureUvIndex = fetchUVForecast(-37, 175);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UVForecast>(
      future: futureUvIndex,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
