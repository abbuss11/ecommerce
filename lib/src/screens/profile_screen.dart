import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../providers/product_providers.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 16),
            Text(profile.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(profile.email),
            const SizedBox(height: 24),
            const Text('Member since', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(profile.memberSince),
            const SizedBox(height: 8),
            Text('Location: ${profile.location}'),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Favorites'),
              subtitle: Text('${ref.watch(favoriteCountProvider)} saved items'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & support'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
