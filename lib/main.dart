import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo_reader/core/routing/app_router.dart';
import 'package:nihongo_reader/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NihongoReaderApp(),
    ),
  );
}

class NihongoReaderApp extends ConsumerWidget {
  const NihongoReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Nihongo Reader',
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
