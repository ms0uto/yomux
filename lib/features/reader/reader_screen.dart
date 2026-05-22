import 'package:flutter/material.dart';
import 'package:nihongo_reader/core/widgets/placeholder_screen.dart';

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Reader',
      subtitle: 'Interactive Japanese reading',
    );
  }
}
