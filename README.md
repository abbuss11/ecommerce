## Riverpod E‑commerce — Exemple Flutter

Ce dépôt contient une application d'exemple e‑commerce développée avec Flutter et Riverpod pour la gestion d'état.

**Points clés**
- Catalogue de produits avec recherche, filtres et tri
- Panier (ajout/suppression, modification de quantités, calculs de totaux)
- Favoris persistés localement (SharedPreferences) avec gestion d'état asynchrone
- Écran profil (données factices) et résumé des favoris
- Support thème clair/sombre (Material 3)

**Architecture (emplacements principaux)**
- `lib/main.dart` — point d'entrée de l'application et shell de navigation
- `lib/src/models` — modèles de données (`Product`, `CartItem`, `UserProfile`)
- `lib/src/repositories` — chargement mock des produits depuis JSON, gestion d'erreurs
- `lib/src/providers` — providers Riverpod (produits, filtres, panier, favoris, profil)
- `lib/src/screens` — vues UI (catalogue, panier, détail produit, profil)

**Gestion d'état (résumé des providers)**
- `productsProvider` : charge le catalogue de produits de façon asynchrone
- `filteredProductsProvider` : applique catégories, recherche et tri tout en conservant les états loading/error
- `cartProvider` : gère les éléments du panier et les quantités
- `favoritesProvider` : persiste les favoris via `SharedPreferences` (expose loading/error)
- `userProfileProvider` : fournit les données de profil pour l'écran Profil

## Prérequis
- Flutter SDK (version stable recommandée)
- Un appareil ou émulateur Android/iOS, ou cible desktop/web configurée

## Installation
1. Récupérer les dépendances :

```bash
flutter pub get
```

2. Lancer l'application sur un appareil connecté ou un émulateur :

```bash
flutter run
```

Pour cibler une plateforme spécifique :

```bash
flutter run -d chrome        # web
flutter run -d windows       # Windows
flutter run -d macos         # macOS
flutter run -d linux         # Linux
flutter run -d <device_id>   # Android / iOS
```

## Tests
Exécuter la suite de tests unitaires et widget :

```bash
flutter test
```

Tests inclus (exemples) :
- Chargement du repository et parsing JSON
- Opérations sur le panier (ajout / mise à jour / suppression)
- Persistance des favoris et état asynchrone
- Comportement de tri/filtrage des produits
- Providers de profil et résumé du panier

## Corrections et bonnes pratiques
- Vérifiez que les fichiers JSON de test sont bien valides (UTF‑8) pour éviter des erreurs de parsing.
- Pour la persistance des favoris, gérez proprement les cas d'erreur et les états transitoires (loading/empty/error).
- Validez les quantités côté UI et modèle (ex : quantité min = 1).

## Structure rapide du projet
- `lib/src/models` — modèles de données
- `lib/src/providers` — logique de state (Riverpod)
- `lib/src/repositories` — accès aux données (mock)
- `lib/src/screens` — écrans et widgets
- `assets/products.json` — données produits utilisées pour le mock

## Contribution
Toutes contributions sont bienvenues : bug reports, corrections de traduction, tests supplémentaires.

1. Ouvrir une issue décrivant le bug ou la proposition
2. Faire une branche, ajouter des tests si pertinent
3. Ouvrir une pull request

