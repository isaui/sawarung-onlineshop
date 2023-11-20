
import 'package:flutter/material.dart';

enum ProductCategory {
  electronics,
  clothing,
  books,
  beauty,
  home,
   gaming,
  sports,
  toys,
  food,
  furniture,
  automotive,
  dailyProduct,
  other,
}
 extension ProductCategoryExtension on ProductCategory {
   String get stringValue {
     switch (this) {
       case ProductCategory.electronics:
         return "Elektronik";
       case ProductCategory.gaming:
         return "Gaming";
       case ProductCategory.clothing:
         return "Pakaian";
       case ProductCategory.books:
         return "Buku";
       case ProductCategory.beauty:
         return "Kecantikan";
       case ProductCategory.home:
         return "Rumah";
       case ProductCategory.sports:
         return "Olahraga";
       case ProductCategory.toys:
         return "Mainan";
       case ProductCategory.food:
         return "Makanan";
       case ProductCategory.furniture:
         return "Perabotan";
       case ProductCategory.automotive:
         return "Otomotif";
       case ProductCategory.dailyProduct:
         return "Barang Sehari-hari";
       case ProductCategory.other:
         return "Lainnya";
     }
   }
   IconData get iconData {
     switch (this) {
       case ProductCategory.electronics:
         return Icons.devices_other;
       case ProductCategory.gaming:
         return Icons.videogame_asset;
       case ProductCategory.clothing:
         return Icons.accessibility;
       case ProductCategory.books:
         return Icons.book;
       case ProductCategory.beauty:
         return Icons.face;
       case ProductCategory.home:
         return Icons.home;
       case ProductCategory.sports:
         return Icons.sports_soccer;
       case ProductCategory.toys:
         return Icons.toys;
       case ProductCategory.food:
         return Icons.restaurant;
       case ProductCategory.furniture:
         return Icons.weekend;
       case ProductCategory.automotive:
         return Icons.directions_car;
       case ProductCategory.dailyProduct:
         return Icons.shopping_bag;
       case ProductCategory.other:
         return Icons.category;
       default:
         return Icons.border_all;
     }
   }
 }

