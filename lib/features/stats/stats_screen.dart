import 'package:flutter/material.dart';
import 'package:nihongo_reader/core/widgets/placeholder_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Stats',
      subtitle: 'Progress and review activity',
    );
  }
}
