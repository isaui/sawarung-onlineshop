import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/models/user.dart';

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(UserData(id: '', username: '', fullName: '', profilePicture: '', dateJoined: '', email: '',
      nomorTelepon: '', alamat: '', description: ''));

  void setUserData(UserData userData) {
    state = userData;
  }

  void clearUserData() {
    state = UserData(id: '', username: '', fullName: '', profilePicture: '', dateJoined: '', email: '',
        nomorTelepon: '', alamat: '', description: '');
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});
