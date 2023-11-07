
import 'package:booking_app/provider/auth_provider.dart';
import 'package:booking_app/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
const baseUrl = 'http://127.0.0.1:8000';

Future<String?> logout(WidgetRef ref, context) async {
  final auth = ref.watch(authNotifierProvider);
  final userData = ref.watch(userDataProvider);
  final url = Uri.parse('$baseUrl/auth/logout/');
  final token = auth.token!;
  print('ini token-> ' + token);
  if(token == null ){
    final snackBar = SnackBar(
      content: Text('Maaf terjadi kesalahan di sisi klien'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return null;
  }
  else{
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ${token}',
    };


    final response = await http.post(
        url,
        body: json.encode({
          'token':token
        }),
        headers: requestHeaders,
    );
    final responseData = json.decode(response.body);
    if(responseData['status'] == 200){
      ref.read(userDataProvider.notifier).clearUserData();
      ref.read(authNotifierProvider.notifier).logout();
      final snackBar = SnackBar(
        content: Text('Kamu telah menekan tombol Logout'),
        backgroundColor: Colors.purple,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return 'SUCCESS';
    }
    else{
      final snackBar = SnackBar(
        content: Text(responseData['message']),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return 'FAILED';
    }

  }



}

Future<String?> login(String? username, String? password, context) async {
  final url = Uri.parse('$baseUrl/auth/login/');
  final data = {
    'username' : username ?? '',
    'password' : password ?? ''
  };
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data)
  );
  final responseData = json.decode(response.body);
  if(responseData['status'] == 200){
    final snackBar = SnackBar(
      content: Text(responseData['message']),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print(responseData['token']);
    return responseData['token'];
  }
  else{
    final snackBar = SnackBar(
      content: Text(responseData['message']),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return null;
}

Future<String> register(String? username, String? fullname, String? email, String? password, String? passwordConfirmation, context) async {
  final url = Uri.parse('$baseUrl/auth/register/');
  final data = {
    'username': username ?? '',
    'fullname': fullname ?? '',
    'email': email ?? '',
    'password1': password ?? '',
    'password2': passwordConfirmation ?? '',
  };
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data)
  );
  final responseData = json.decode(response.body);
  print(responseData);
  print(responseData['status']);
  if(responseData['status'] == 201){
    print('Registrasi berhasil');
    final snackBar = SnackBar(
      content: Text(responseData['message']),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return 'SUCCESS';
  }
  else{
    print('Registrasi gagal');
    final snackBar = SnackBar(
      content: Text(responseData['message']),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return 'FAILED';
}