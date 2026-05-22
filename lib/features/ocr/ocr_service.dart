import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:nihongo_reader/features/ocr/ocr_image_preparer.dart';

/// On-device Japanese text recognition via ML Kit.
///
/// Requires native language packs:
/// - iOS: `GoogleMLKit/TextRecognitionJapanese` in Podfile
/// - Android: `text-recognition-japanese` in app `build.gradle.kts`
class OcrService {
  static const TextRecognitionScript _script = TextRecognitionScript.japanese;

  /// Recognizes text using [TextRecognizer] with Japanese script (not Latin default).
  /// Creates and closes a recognizer for each call.
  Future<String> recognizeFromFile(
    String filePath, {
    String? source,
  }) async {
    final preparedPath = await OcrImagePreparer.prepareForRecognition(filePath);
    final recognizer = TextRecognizer(script: _script);
    try {
      debugPrint(
        '[OcrService] source=$source script=japanese '
        'original=$filePath prepared=$preparedPath',
      );
      final inputImage = InputImage.fromFilePath(preparedPath);
      final result = await recognizer.processImage(inputImage);
      final text = result.text.trim();
      debugPrint(
        '[OcrService] script=TextRecognitionScript.japanese '
        '(${text.length} chars):\n$text',
      );
      return text;
    } finally {
      await recognizer.close();
      if (preparedPath != filePath) {
        try {
          await File(preparedPath).delete();
        } catch (_) {}
      }
    }
  }
}
