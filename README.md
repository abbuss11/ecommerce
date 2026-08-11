# Riverpod E-commerce App

This project is a Flutter e-commerce sample built with Riverpod for state management.

## Features
- Product catalog with search, filtering, and sorting
- Cart management with quantity updates, quantity validation, and totals
- Favorites persisted via SharedPreferences with async state handling
- Profile screen with mock user data and favorites summary
- Dark/light theming through Material 3

## Architecture
- lib/main.dart: app entrypoint and bottom navigation shell
- lib/src/models: data models for Product, CartItem, and UserProfile
- lib/src/repositories: mock product loading logic with JSON error handling
- lib/src/providers: Riverpod providers for products, filters, cart state, favorites persistence, and user profile
- lib/src/screens: UI screens for catalog, cart, product detail, and profile

## State Management
- `productsProvider`: loads product catalog asynchronously
- `filteredProductsProvider`: applies category, search, and sorting to product results while preserving loading/error states
- `cartProvider`: manages shopping cart items and quantities
- `favoritesProvider`: persists favorites using `SharedPreferences` and exposes loading/error states
- `userProfileProvider`: exposes profile data for the profile screen

## Testing
Run `flutter test` to execute widget and provider tests.

Included tests cover:
- repository loading and JSON parsing
- cart add/update/remove operations
- favorites persistence and async state
- sort order behavior for filtered products
- profile provider data and cart summary providers
