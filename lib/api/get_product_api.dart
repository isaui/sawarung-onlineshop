import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:booking_app/provider/auth_provider.dart';
import 'package:uuid/uuid.dart';
const baseUrl = 'https://sawarungdjangoapi-production.up.railway.app';

Future<Map<String, dynamic>> getProducts(WidgetRef ref) async {
  final url = Uri.parse('$baseUrl/products/get-products/');
  final auth = ref.watch(authNotifierProvider);
  final String token = auth.token!;
  final data = {
    'token':token
  };
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data)
  );
  final responseData = json.decode(response.body);
  if(responseData['status'] == 200){
    return {
      'products': responseData['products'],
      'message': 'SUCCESS'
    };
  }
  return {
    'products': [],
    'message' : 'FAILED'
  };
}