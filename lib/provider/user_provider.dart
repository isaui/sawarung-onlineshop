import 'package:flutter_riverpod/flutter_riverpod.dart';
class UserData {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;

  UserData({required this.id, required this.username, required this.fullName, required this.profilePicture});
}

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(null);

  void setUserData(UserData userData) {
    state = userData;
  }

  void clearUserData() {
    state = null;
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});
