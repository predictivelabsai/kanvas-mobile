import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kanvas/config/theme.dart';
import 'package:kanvas/providers/connectivity_provider.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOnline = connectivityAsync.whenOrNull(data: (v) => v) ?? true;

    return Scaffold(
      body: Column(
        children: [
          if (!isOnline)
            MaterialBanner(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              content: Text(
                'No internet connection',
                style: TextStyle(fontSize: 13, color: AppTheme.gray500),
              ),
              leading: Icon(Icons.wifi_off, size: 20, color: AppTheme.gray500),
              backgroundColor: AppTheme.gray100,
              actions: const [SizedBox.shrink()],
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
