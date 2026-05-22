import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Normalizes picked images (gallery HEIC/JPEG with EXIF, camera JPEG) for ML Kit.
abstract final class OcrImagePreparer {
  /// Decodes the image, applies baked-in orientation, and writes an upright PNG.
  /// Falls back to [sourcePath] if decoding fails (e.g. unsupported format).
  static Future<String> prepareForRecognition(String sourcePath) async {
    try {
      final bytes = await File(sourcePath).readAsBytes();
      if (bytes.isEmpty) {
        debugPrint('[OcrImagePreparer] empty file, using original: $sourcePath');
        return sourcePath;
      }

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      try {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) {
          debugPrint('[OcrImagePreparer] PNG encode failed, using original');
          return sourcePath;
        }

        final tempDir = await getTemporaryDirectory();
        final outPath = p.join(
          tempDir.path,
          'ocr_${DateTime.now().microsecondsSinceEpoch}.png',
        );
        await File(outPath).writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
          flush: true,
        );
        debugPrint('[OcrImagePreparer] prepared PNG: $outPath');
        return outPath;
      } finally {
        image.dispose();
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[OcrImagePreparer] prepare failed ($sourcePath), using original: $error',
      );
      debugPrint('$stackTrace');
      return sourcePath;
    }
  }
}
