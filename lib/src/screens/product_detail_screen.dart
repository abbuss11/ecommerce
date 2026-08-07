import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          favoritesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
            error: (error, stack) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.error_outline),
            ),
            data: (favoriteIds) {
              final isFavorite = favoriteIds.contains(product.id);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.image,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 260,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(product.category, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Text('Price', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(cartProvider.notifier).addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}
