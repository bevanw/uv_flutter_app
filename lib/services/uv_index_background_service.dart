import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/niwa/models/uv_index.dart';
import '../../providers/api_providers.dart';
import 'uv_index_notifier.dart';

class UVIndexBackgroundService {
  final FlutterBackgroundService backgroundSerivce;
  final UVIndexNotifierService uvIndexNotifierService;
  final UVParameters uvParameters;
  const UVIndexBackgroundService({required this.backgroundSerivce, required this.uvIndexNotifierService, required this.uvParameters});

  void initialiseBackgroundService() async {
    await backgroundSerivce.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: null,
      ),
    );
    backgroundSerivce.startService();
  }

  Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    // if (service is AndroidServiceInstance) {
    //   service.on('setAsForeground').listen((event) {
    //     service.setAsForegroundService();
    //   });
    //   service.on('setAsBackground').listen((event) {
    //     service.setAsBackgroundService();
    //   });
    // }
    // service.on('stopService').listen((event) {
    //   service.stopSelf();
    // });
  }
}
