import '../../providers/api_providers.dart';
import 'uv_index_notifier_service.dart';

class UVIndexBackgroundService {
  final UVIndexNotifierService uvIndexNotifierService;
  final UVParameters uvParameters;
  const UVIndexBackgroundService({required this.uvIndexNotifierService, required this.uvParameters});

  // TODO: Use background worker: https://pub.dev/packages/workmanager
}
