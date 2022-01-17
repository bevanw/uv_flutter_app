import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../apis/uv_current_svg_service.dart';

class UVIndexTab extends StatefulWidget {
  const UVIndexTab({Key? key}) : super(key: key);

  @override
  _UVIndexTab createState() => _UVIndexTab();
}

class _UVIndexTab extends State<UVIndexTab> {
  late Future<SvgPicture> futureUvIndex;

  @override
  void initState() {
    super.initState();
    futureUvIndex = fetchUVIndexSvg(-39, 174, SkyTypes.clear);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SvgPicture>(
      future: futureUvIndex,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
