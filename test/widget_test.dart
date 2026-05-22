import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo_reader/main.dart';

void main() {
  testWidgets('Home screen shows main actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NihongoReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yomu'), findsOneWidget);
    expect(find.text('Scan it. Read it. Remember it.'), findsOneWidget);
    expect(find.text('Keep learning'), findsOneWidget);
    expect(find.text('Start reading'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Import'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });
}
