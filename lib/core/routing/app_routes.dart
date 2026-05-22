abstract final class AppRoutes {
  static const home = '/';
  static const ocr = '/ocr';
  static const reader = '/reader';
  static const flashcards = '/flashcards';
  static const stats = '/stats';

  static String ocrWithMode(String mode) => '$ocr?mode=$mode';
}
