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
 }
