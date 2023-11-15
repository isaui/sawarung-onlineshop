import 'package:booking_app/api/add_product_api.dart';
import 'package:booking_app/component/drawer.dart';
import 'package:booking_app/component/mini_image_container.dart';
import 'package:booking_app/api/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../models/category.dart';

class AddProductsPage extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
   return _AddProductsPageState();
  }
}
class _AddProductsPageState extends ConsumerState{

  // CLEAR
  List<Uint8List> productsImage = [];
  late List<Map<String, dynamic>> productCategories = mapProductCategories();
  List<Map<String, dynamic>> mapProductCategories() {
    return ProductCategory.values.map((category) {
      return {
        'enumValue': category.name,
        'stringValue': category.stringValue,
        'isSelected' : false
      };
    }).toList();
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  bool isForSale = false;

  // CLEAR
  @override
  void dispose() {
    // TODO: implement dispose
    productNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> onSubmit () async {
    if(_formKey.currentState!.validate()){
      final selectedCategories = productCategories.where((categoryData) => categoryData['isSelected']).toList();
      print(selectedCategories);
      if(selectedCategories.length == 0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Anda harus minimal memilih satu kategori'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      if(productsImage.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Mohon Tambahkan minimal satu gambar produk Anda'),
            backgroundColor: Colors.red,
        ));
        return;
      }
      print('Anda berhasil melewati ini');
      final List<String> imageUrls = [];
      print('ini product images kamu:');
      for(final imageUin8List in productsImage){
        final url = await uploadImageToFirebaseWeb(imageUin8List);
        imageUrls.add(url!);
      }
      final res = await addProduct(productNameController.text,
          int.parse(priceController.text), int.parse(stockController.text),
          descriptionController.text, selectedCategories.map((e) => e['enumValue'].toString()).toList(),
          imageUrls, isForSale, ref);
      print(res);
      if(res == 'SUCCESS'){

        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Contoh Dialog'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama produk: ${productNameController.text}'),
                    Text('Harga: ${priceController.text}'),
                    Text('Deskripsi: ${descriptionController.text}'),
                    Text('Stok: ${stockController.text}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Tutup dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Tutup'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk Anda'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Atur warna ikon hamburger
              onPressed: () {
                Navigator.of(context).pop(); // Tindakan ketika hamburger diklik
              },
            );
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.refresh, size: 28,)),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white), // Atur warna ikon hamburger
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Tindakan ketika hamburger diklik
                },
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: productNameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Nama Produk',
                          hintText: 'Masukkan Nama Produk Anda',
                          prefixIcon: Icon(Icons.abc),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator:  (value) {
                            if (value!.isEmpty) {
                              return 'Nama Produk tidak boleh kosong';
                            }
                            if (value!.length < 4) {

                              return 'Nama Produk minimal 4 karakter';
                            }
                            return null;
                            },
                      ), // CLEAR
                      SizedBox(height: 16.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: priceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Custom formatter untuk format harga
                        ],
                        decoration: InputDecoration(
                          labelText: 'Harga Produk',
                          hintText: 'Masukkan Harga Produk Anda',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.money_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),

                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Harga Produk tidak boleh kosong';
                          }

                          try {
                            final price = int.parse(value!);
                            if (price < 1) {
                              return 'Harga Produk tidak boleh kurang dari 1';
                            }
                          } catch (e) {
                            return 'Harga Produk harus berupa angka';
                          }

                          return null;
                        },
                      ), // CLEAR
                      SizedBox(height: 16,),
                      TextFormField(
                        minLines: 4,
                        maxLines: 4,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Produk',
                          hintText: 'Masukkan Deskripsi Produk Anda',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Deskripsi Produk tidak boleh kosong';
                          }

                          final words = value.trim().split(' ');
                          if (words.length < 12) {

                            return 'Deskripsi Produk minimal terdiri dari 12 kata';
                          }

                          return null;
                        },

                      ), // CLEAR
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Foto Produk', style:TextStyle(color: Colors.grey)),
                          IconButton(onPressed:  () async {
                            // todo: pakai image picker untuk mendapatkan uin8list
                            final imagePicker = ImagePicker();
                            final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                            if(pickedFile != null){
                              Uint8List imageBytes = await pickedFile.readAsBytes();
                              setState(() {
                                productsImage.add(imageBytes);
                              });
                            }
                          }, icon: Icon(Icons.add_circle))
                        ],
                      ),
                      productsImage.length != 0?
                      LayoutBuilder(builder: (context, constraints){
                        return Container(
                          width: constraints.maxWidth,
                          height: 200,
                            child:MiniImageContainer(function: (index){
                              setState(() {
                                productsImage.removeAt(index);
                              });
                            }, imagesData: productsImage)
                        );
                      })
                          :
                      LayoutBuilder(builder: (context, constraints){
                        return Container(

                          height: 200,
                          child: Center(
                            child: Text('Belum ada produk', style: TextStyle(color: Colors.grey),),
                          ),
                        );
                      }),
                      SizedBox(height: 8,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller:stockController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Custom formatter untuk format harga
                        ],
                        decoration: InputDecoration(
                          labelText: 'Stok Produk',
                          hintText: 'Masukkan Stok Produk Anda',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.money_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),

                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Stok Produk tidak boleh kosong';
                          }

                          final stock = int.tryParse(value);
                          if (stock == null || stock <= 0) {
                            return 'Stok Produk harus lebih dari 0';
                          }

                          return null; // Return null jika validasi berhasil
                        },
                      ), //CLEAR
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Kategori', style:TextStyle(color: Colors.grey)),
                        ],

                      ),
                      SizedBox(height: 12,),
                      LayoutBuilder(builder: (context, constraints){
                        return Container(
                          width: constraints.maxWidth,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 4,
                            runSpacing: 6,
                            children: [
                              ...productCategories.map((categoryData){
                                String stringValue = categoryData['stringValue'];
                                return !categoryData['isSelected']?
                                OutlinedButton(onPressed: (){
                                  setState((){
                                    categoryData['isSelected'] = ! categoryData['isSelected'];
                                  });
                                }, child:
                                Text('${stringValue}'
                                )) :
                                ElevatedButton(onPressed: (){
                                  setState((){
                                    categoryData['isSelected'] = ! categoryData['isSelected'];
                                  });
                                }, child:
                                Text('${stringValue}'
                                )) ;
                              }).toList()
                            ],
                          ) ,
                        );
                      }),
                      SizedBox(height: 18,),
                      LayoutBuilder(builder: (context, constraints){
                        return Container(
                          width: constraints.maxWidth,
                          child: Wrap(

                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('Apakah Anda ingin Menjualnya?', style:TextStyle(color: Colors.grey)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isForSale = true;
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: isForSale ? Colors.blue : Colors.grey,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Ya',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6,),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isForSale = false;
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: !isForSale ? Colors.blue : Colors.grey,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Tidak',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],

                          ),
                        );
                      })
                    ],
                  ),
                ),
              )
            )),
            Container(
              width: double.infinity - 40,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ElevatedButton(
                onPressed: (){
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0), // Sesuaikan nilai padding sesuai kebutuhan
                ),
                child: Text('Tambah Produk'),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}