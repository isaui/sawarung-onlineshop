import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:booking_app/provider/auth_provider.dart';
import 'package:uuid/uuid.dart';
const baseUrl = 'http://127.0.0.1:8000';

Future<String> addProduct(String nama, int harga, int stok,
String deskripsi, List<String> kategori, List<String> gambar, bool forSale, WidgetRef ref) async{
   final url = Uri.parse('$baseUrl/products/create-product/');
   final uuid = Uuid(); // Buat instance Uuid
   final productId = uuid.v4();
   final auth = ref.watch(authNotifierProvider);
   final token = auth.token!;
   final data = {
     'token': token,
     'nama' : nama,
     'productId' : productId,
     'harga':harga,
     'stok':stok,
     'deskripsi': deskripsi,
     'kategori': kategori,
     'gambar':gambar,
     'for_sale': forSale
   };
   print(gambar);
   final response = await http.post(
       url,
       headers: {'Content-Type': 'application/json'},
       body: json.encode(data)
   );
   final responseData = json.decode(response.body);
   if(responseData['status'] == 200){
     print(responseData);
     return 'SUCCESS';
   }
   print(responseData);
   return 'FAILED';
}