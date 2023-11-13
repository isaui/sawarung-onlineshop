import 'package:flutter_riverpod/flutter_riverpod.dart';
class RegisterData {
  final String? password;
  final String? confirmPassword;
  final String? username;
  final String? fullName;
  final String? profilePicture;
  final String? email;

  RegisterData({required this.username, required this.password, required this.confirmPassword,
    required this.fullName, required this.profilePicture, required this.email});
  RegisterData copyWith({
    String? username,
    String? password,
    String? confirmPassword,
    String? fullName,
    String? profilePicture,
    String? email,
  }) {
    return RegisterData(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
    );
  }
  Map<String, dynamic> toDict() {
    return {
      'username': username ?? '',
      'password1': password ?? '',
      'password2': confirmPassword ?? '',
      'fullname': fullName ?? '',
      'profile_picture': profilePicture ?? '',
      'email': email ?? '',
    };
  }
}

class RegisterDataNotifier extends StateNotifier<RegisterData?> {
  RegisterDataNotifier() : super(RegisterData(password: '', username: '', fullName: '', profilePicture: '',
      confirmPassword: '', email: ''));

  void setRegisterData(RegisterData userData) {
    state = userData;
  }

  void clearRegisterData() {
    state = RegisterData(password: '', username: '', fullName: '', profilePicture: '',
        confirmPassword: '', email: '');
  }
  void addProfilePicture(String profilePicture){
    state = state!.copyWith(profilePicture: profilePicture );
  }
}

final registerDataNotifier = StateNotifierProvider<RegisterDataNotifier, RegisterData?>((ref) {
  return RegisterDataNotifier();
});
