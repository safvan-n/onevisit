import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:onevisit/main.dart';
import 'package:onevisit/services/app_state.dart';

void main() {
  testWidgets('OneVisit app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const OneVisitApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.byType(OneVisitApp), findsOneWidget);
  });
}
