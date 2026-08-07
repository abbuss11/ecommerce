import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project3/src/models/product.dart';
import 'package:project3/src/providers/product_providers.dart';
import 'package:project3/src/repositories/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ProductRepository loads the mock catalog', () async {
    final repository = ProductRepository();

    final products = await repository.loadProducts();

    expect(products, isNotEmpty);
    expect(products.first.name, 'Classic Tee');
    expect(products.first.category, 'Clothing');
  });

  test('CartNotifier adds, updates, and removes products', () {
    final notifier = CartNotifier();
    const product = Product(
      id: 1,
      name: 'Classic Tee',
      description: 'Comfortable',
      price: 24.99,
      category: 'Clothing',
      image: 'https://example.com/tee.png',
    );

    notifier.addProduct(product);
    expect(notifier.state[1]!.quantity, 1);

    notifier.updateQuantity(1, 3);
    expect(notifier.state[1]!.quantity, 3);
    expect(notifier.total, 74.97);

    notifier.removeProduct(1);
    expect(notifier.state, isEmpty);
  });

  test('FavoritesNotifier toggles persisted favorites', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.toggleFavorite(7);

    final favorites = await container.read(favoritesProvider.future);
    expect(favorites, contains(7));
  });
}
