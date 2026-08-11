import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project3/src/models/product.dart';
import 'package:project3/src/providers/product_providers.dart';
import 'package:project3/src/providers/user_provider.dart';
import 'package:project3/src/repositories/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('filteredProductsProvider sorts results correctly when price ascending', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(sortOrderProvider.notifier).state = SortOrder.priceAsc;
    final products = await container.read(filteredProductsProvider.future);

    expect(products, isNotEmpty);
    final prices = products.map((product) => product.price).toList();
    final sortedPrices = [...prices]..sort();
    expect(prices, equals(sortedPrices));
  });

  test('favoritesProvider persists favorite ids across toggles', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.toggleFavorite(7);
    await container.read(favoritesProvider.future);
    expect(container.read(favoritesProvider).value, contains(7));

    final secondContainer = ProviderContainer();
    addTearDown(secondContainer.dispose);
    final loadedFavorites = await secondContainer.read(favoritesProvider.future);
    expect(loadedFavorites, contains(7));
  });

  test('userProfileProvider exposes mock user data', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final profile = container.read(userProfileProvider);
    expect(profile.name, 'Jane Doe');
    expect(profile.email, contains('@')); 
  });

  test('cart summary providers calculate correct values', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final product = Product(
      id: 1,
      name: 'Classic Tee',
      description: 'Comfortable',
      price: 20.0,
      category: 'Clothing',
      image: 'https://example.com/tee.png',
    );

    container.read(cartProvider.notifier).addProduct(product);
    container.read(cartProvider.notifier).updateQuantity(1, 2);

    expect(container.read(cartItemCountProvider), 2);
    expect(container.read(cartTotalProvider), 40.0);
  });
}
