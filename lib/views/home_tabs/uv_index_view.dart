import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/niwa/models/skye_types.dart';
import '../../apis/niwa/models/uv_index.dart';
import '../../providers/http_providers.dart';

class UVIndexTab extends ConsumerStatefulWidget {
  const UVIndexTab({Key? key}) : super(key: key);

  @override
  ConsumerState<UVIndexTab> createState() => _UVIndexTab();
}

class _UVIndexTab extends ConsumerState<UVIndexTab> {
  late Future<UVIndex> futureUvIndex;

  @override
  void initState() {
    super.initState();
    final niwaApiService = ref.watch(niwaApiServiceProvider);
    futureUvIndex = niwaApiService.fetchUVIndex(-37, 175, SkyTypes.clear);
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
