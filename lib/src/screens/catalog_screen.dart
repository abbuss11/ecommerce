import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_providers.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  static const categories = <String>['All', 'Clothing', 'Shoes', 'Accessories', 'Electronics'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);
    final sortOrder = ref.watch(sortOrderProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                TextFormField(
                  initialValue: searchQuery,
                  decoration: const InputDecoration(
                    labelText: 'Search products',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCategory ?? 'All',
                        items: categories
                            .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                            .toList(),
                        onChanged: (value) {
                          ref.read(categoryFilterProvider.notifier).state =
                              value == 'All' ? null : value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<SortOrder>(
                        initialValue: sortOrder,
                        items: const [
                          DropdownMenuItem(value: SortOrder.none, child: Text('Default')),
                          DropdownMenuItem(value: SortOrder.priceAsc, child: Text('Price ↑')),
                          DropdownMenuItem(value: SortOrder.priceDesc, child: Text('Price ↓')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(sortOrderProvider.notifier).state = value;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Sort',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Failed to load products: $error')),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No matching products.'));
                }

                return favoritesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 32),
                        const SizedBox(height: 8),
                        Text('Favorites could not be loaded: $error'),
                      ],
                    ),
                  ),
                  data: (favoriteIds) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isFavorite = favoriteIds.contains(product.id);
                        return _ProductCard(
                          product: product,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                          onAddCart: () => ref.read(cartProvider.notifier).addProduct(product),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: product),
                            ));
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddCart,
    required this.onTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 92,
                      height: 92,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(product.category, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 88),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                      onPressed: onFavoriteToggle,
                    ),
                    ElevatedButton(
                      onPressed: onAddCart,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
