import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

/// Provides the repository used by the catalog and detail screens.
final productRepositoryProvider = Provider<ProductRepository>((_) {
  return ProductRepository();
});

/// Loads the mock products from the repository.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.loadProducts();
});

enum SortOrder { none, priceAsc, priceDesc }

final categoryFilterProvider = StateProvider<String?>((_) => null);
final sortOrderProvider = StateProvider<SortOrder>((_) => SortOrder.none);
final searchQueryProvider = StateProvider<String>((_) => '');

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final category = ref.watch(categoryFilterProvider);
  final sortOrder = ref.watch(sortOrderProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return productsAsync.when(
    data: (products) {
      return AsyncValue.data(_applyProductFilters(
        products: products,
        category: category,
        sortOrder: sortOrder,
        searchQuery: searchQuery,
      ));
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

List<Product> _applyProductFilters({
  required List<Product> products,
  required String? category,
  required SortOrder sortOrder,
  required String searchQuery,
}) {
  var filtered = products;
  if (category != null && category.isNotEmpty) {
    filtered = filtered.where((product) => product.category == category).toList();
  }
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery);
    }).toList();
  }
  switch (sortOrder) {
    case SortOrder.priceAsc:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOrder.priceDesc:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOrder.none:
      break;
  }
  return filtered;
}

/// Maintains the current shopping cart state.
class CartNotifier extends StateNotifier<Map<int, CartItem>> {
  CartNotifier() : super({});

  void addProduct(Product product) {
    state = {
      ...state,
      product.id: state.containsKey(product.id)
          ? state[product.id]!.copyWith(quantity: state[product.id]!.quantity + 1)
          : CartItem(product: product, quantity: 1),
    };
  }

  void removeProduct(int productId) {
    final current = Map<int, CartItem>.from(state);
    current.remove(productId);
    state = current;
  }

  void updateQuantity(int productId, int quantity) {
    if (!state.containsKey(productId)) return;
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    state = {
      ...state,
      productId: state[productId]!.copyWith(quantity: quantity),
    };
  }

  double get total => state.values.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<int, CartItem>>((_) {
  return CartNotifier();
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).values.fold(0, (count, item) => count + item.quantity);
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).values.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
});

/// Persists and exposes the set of favorite product ids.
class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  static const _prefsKey = 'favoriteProductIds';

  @override
  Future<Set<int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? <String>[];
    return stored.map(int.parse).toSet();
  }

  Future<void> toggleFavorite(int productId) async {
    final current = state.value ?? <int>{};
    final next = Set<int>.from(current);
    if (next.contains(productId)) {
      next.remove(productId);
    } else {
      next.add(productId);
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, next.map((id) => id.toString()).toList());
      return next;
    });
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<int>>(() {
  return FavoritesNotifier();
});

final favoriteCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).when(
        data: (favorites) => favorites.length,
        loading: () => 0,
        error: (_, __) => 0,
      );
});