import 'package:booking_app/models/user.dart';

class ShopItem {
  final String itemId;
  final Map<String, dynamic> itemData;
  final UserData owner;
  const ShopItem({
    required this.itemId,
    required this.itemData,
    required this.owner,
  });
}
