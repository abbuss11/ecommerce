import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project3/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('catalog screen renders the shopping experience', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ShopApp()));
    await tester.pumpAndSettle();

    expect(find.text('Search products'), findsOneWidget);
    expect(find.text('Classic Tee'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });
}
