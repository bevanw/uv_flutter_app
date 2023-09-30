class UVForecast {
  final List<UVIndex> clearSky;
  final List<UVIndex> cloudySky;

  UVForecast({
    required this.clearSky,
    required this.cloudySky,
  });

  /// Fetches a specific [UVIndex] by [skyType]
  UVIndex fetchUvIndex(SkyTypes skyType) {
    switch (skyType) {
      // TODO: Fetch UV index by hour? Then update uv_index.dart (view) to show the current UV index.
      // TODO: Also get unit/integration tests working.
      case SkyTypes.clear:
        return clearSky[1];
      case SkyTypes.cloudy:
        return cloudySky[1];
    }
  }
}

class UVIndex {
  final DateTime time;
  final num value;

  UVIndex({
    required this.time,
    required this.value,
  });
}

enum SkyTypes {
  cloudy,
  clear,
}
