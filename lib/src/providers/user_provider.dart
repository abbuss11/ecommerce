import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';

final userProfileProvider = Provider<UserProfile>((_) {
  return const UserProfile(
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    memberSince: 'January 2026',
    location: 'San Francisco, CA',
  );
});
