import 'package:flutter/material.dart';
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

  testWidgets('product detail screen displays details when product selected', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ShopApp()));
    await tester.pumpAndSettle();

    expect(find.text('Classic Tee'), findsOneWidget);
    await tester.tap(find.text('Classic Tee').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Classic Tee'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);
  });

  testWidgets('profile screen shows user profile data and favorites summary', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ShopApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.text('jane.doe@example.com'), findsOneWidget);
    expect(find.textContaining('saved items'), findsOneWidget);
  });
}
