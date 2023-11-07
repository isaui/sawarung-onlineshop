import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? token; // Gantilah dengan tipe data yang sesuai dengan ID pengguna Anda
  AuthState(this.status, {this.token});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(AuthState state) : super(state);

  // Fungsi untuk login pengguna
  Future<void> login(String token) async {
    // Implementasi logika login di sini
    // Misalnya, panggil endpoint login dengan username dan password

    // Jika berhasil, atur status otentikasi menjadi authenticated
    state = AuthState(AuthStatus.authenticated, token: token);
  }

  // Fungsi untuk logout pengguna
  Future<void> logout() async {
    // Implementasi logika logout di sini
    // Misalnya, hapus token otentikasi

    // Atur status otentikasi menjadi unauthenticated
    state = AuthState(AuthStatus.unauthenticated);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Menginisialisasi provider dengan status otentikasi awal
  return AuthNotifier(AuthState(AuthStatus.unauthenticated));
});
