import 'package:actilink/app/app.dart';
import 'package:actilink/empty/empty.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('Renders EmptyPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(EmptyPage), findsOneWidget);
    });
  });
}
