import 'dart:convert';


import 'package:booking_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/models/shop_item.dart';
const baseUrl = 'sawarungdjangoapi-production.up.railway.app';

WebSocketChannel? channel;
bool reconnecting = false;

Future<void> setSocket(String token, WidgetRef ref) async {
  final wsUrl = Uri.parse('wss://$baseUrl/ws/products/$token/');
  channel = WebSocketChannel.connect(wsUrl);
  print("WebSocket connection established");
  channel!.stream.listen((message) {
    print('Received: $message');
    final messageData = jsonDecode(message);
    final messageType = messageData['type'];
    switch(messageType){
      case 'product':
        final ownerData = messageData['product_data']['pemilik'];
        final productData = messageData['product_data']['product'];
        final itemId = messageData['product_data']['product']['id_produk'];
        print(messageData['product_data']['review_produk']);
        // update riverpod provider
        UserData owner = UserData.fromJson(ownerData);
        ShopItem item = ShopItem(itemId: itemId, itemData: productData, owner: owner);
        print(item);
        ref.read(shopItemProviders.notifier).addItem(item);


    }
  }, onDone: () {
    if (!reconnecting) {
      reconnecting = true;
      print("WebSocket connection closed unexpectedly. Trying to reconnect in 2s...");
      Future.delayed(Duration(seconds: 2), () {
        print("Reconnecting...");
        setSocket(token, ref); // Reconnect ketika koneksi ditutup
        reconnecting = false;
      });
    }
  });
}
