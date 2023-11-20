import 'package:booking_app/models/sort_preference.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/models/shop_item.dart';
import 'package:booking_app/provider/container.dart';
class ShopItemsNotifier extends StateNotifier<Map<String, ShopItem>> {
  ShopItemsNotifier(Map<String, ShopItem> state) : super(state);
  void addItem(ShopItem item) {
    state = {...state, item.itemId: item};
  }
  void removeItem(String itemId) {
    state = Map.from(state)..remove(itemId);
  }
  void updateItem(String itemId, ShopItem newItem) {
    if (state.containsKey(itemId)) {
      state = {...state, itemId: newItem};
    }
  }
  List<ShopItem> getAllItems() {
    return state.values.toList();
  }
  List<ShopItem> getAllItemsSortBy(SortPreference preference) {
    return state.values.toList(); // TODO
  }

  ShopItem? getItemById(String itemId) {
    return state[itemId];
  }
  void clearItems() {
    state = {};
  }
  void setItems(Map<String, ShopItem> newState){
    state = newState;
  }
}

final shopItemProviders = StateNotifierProvider<ShopItemsNotifier, Map<String, ShopItem>>((ref) {
  return ShopItemsNotifier({});
});
