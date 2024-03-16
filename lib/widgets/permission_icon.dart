import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';

class PermissionIcon extends ConsumerWidget {
  const PermissionIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationPermissionsAsyncValue = ref.watch(notificationPermissionsProvider);

    return notificationPermissionsAsyncValue.when(
      data: (permissions) => permissions.isPermissionsGranted ? const Icon(Icons.notifications_active_outlined) : const Icon(Icons.notifications_off_outlined),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Icon(Icons.error_outline),
    );
  }
}
