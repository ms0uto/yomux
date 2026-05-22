import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo_reader/core/routing/app_routes.dart';
import 'package:nihongo_reader/features/flashcards/flashcards_screen.dart';
import 'package:nihongo_reader/features/home/home_screen.dart';
import 'package:nihongo_reader/features/ocr/ocr_screen.dart';
import 'package:nihongo_reader/features/reader/reader_screen.dart';
import 'package:nihongo_reader/features/stats/stats_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.ocr,
        builder: (context, state) {
          final mode = state.uri.queryParameters['mode'] ?? 'camera';
          return OcrScreen(mode: mode);
        },
      ),
      GoRoute(
        path: AppRoutes.reader,
        builder: (context, state) => const ReaderScreen(),
      ),
      GoRoute(
        path: AppRoutes.flashcards,
        builder: (context, state) => const FlashcardsScreen(),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
    ],
  );
});
