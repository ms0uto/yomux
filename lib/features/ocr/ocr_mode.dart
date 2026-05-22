enum OcrMode {
  camera('camera'),
  gallery('gallery');

  const OcrMode(this.routeValue);

  final String routeValue;

  static OcrMode fromRoute(String? value) {
    return switch (value) {
      'gallery' => OcrMode.gallery,
      _ => OcrMode.camera,
    };
  }

  String get screenTitle => switch (this) {
        OcrMode.camera => 'Scan',
        OcrMode.gallery => 'Import',
      };
}
