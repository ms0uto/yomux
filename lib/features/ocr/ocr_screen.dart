import 'package:flutter/material.dart';
import 'package:nihongo_reader/core/widgets/placeholder_screen.dart';

class OcrScreen extends StatelessWidget {
  const OcrScreen({super.key, required this.mode});

  final String mode;

  String get _modeLabel {
    return switch (mode) {
      'gallery' => 'Gallery import',
      'camera' => 'Camera scan',
      _ => mode,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'OCR',
      subtitle: 'Mode: $_modeLabel',
    );
  }
}
