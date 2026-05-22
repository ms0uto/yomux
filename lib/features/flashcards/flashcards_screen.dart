import 'package:flutter/material.dart';
import 'package:nihongo_reader/core/widgets/placeholder_screen.dart';

class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Flashcards',
      subtitle: 'Review saved vocabulary',
    );
  }
}
