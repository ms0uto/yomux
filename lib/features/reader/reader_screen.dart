import 'package:flutter/material.dart';

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasText = text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: SafeArea(
        child: hasText
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    height: 1.7,
                    letterSpacing: 0.2,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 56,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No text to read',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan or import an image, then tap Start reading.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
