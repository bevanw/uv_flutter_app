import 'package:flutter/material.dart';

import '../../apis/uv_index.dart';
import '../../apis/uv_index_service.dart';

class UVIndexTab extends StatefulWidget {
  const UVIndexTab({Key? key}) : super(key: key);

  @override
  _UVIndexTab createState() => _UVIndexTab();
}

class _UVIndexTab extends State<UVIndexTab> {
  late Future<UVIndex> futureUvIndex;

  @override
  void initState() {
    super.initState();
    futureUvIndex = fetchUVIndex(-39, 174, SkyTypes.clear);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UVIndex>(
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
