# Sawarung - Warung Online
Projek Sawarung adalah aplikasi warung online yang revolusioner. Dibangun dengan teknologi flutter dan django, Sawarung memungkinkan pengguna untuk memesan makanan, minuman, dan barang-barang sehari-hari dari orang lain atau warung-warung lokal favorit mereka dengan mudah melalui aplikasi seluler atau situs web. Jual beli easy, ga perlu buat toko, semua bisa pakai!

## Tugas Flutter
Nama: Isa Citra Buana
NPM: 2206081465
Kelas: PBP D

TUGAS 8
1. Navigator.push akan menambahkan halaman yang dituju ke dalam navigation stack sehingga ketika halaman yang dituju itu di-pop, maka halaman yang sebelumnya akan ditampilkan sementara Navigator.pushReplacement juga menambahkan halaman yang akan dituju itu ke dalam navigation stack tetapi mengganti halaman saat ini dengan halaman yang akan dituju. 
Contoh Navigator.push:
``Navigator.of(context).push(MaterialPageRoute(builder: (context){
   return AddProductsPage();
   }));``
Ketika kita berada di halaman utama dan kita ingin menambahkan produk, maka kita harus push ke halaman tambah produk karena kita pasti akan kembali ke halaman utama setelah membuat produk.
Contoh Navigator.pushReplacement:
``Navigator.of(context).push(MaterialPageRoute(builder:(context){
return AppPage();
}));``
Ketika kita telah login dan berhasil diautentikasi, kita harus masuk ke konten aplikasi dan kita tidak berharap untuk kembali ke login page lagi.

2. Ada 6.
- Stack
  memungkinkan penumpukan widget-child di atas satu sama lain. Widget dalam Stack ditempatkan relatif terhadap satu sama lain menggunakan properti-position-widget seperti Positioned. Biasanya stack digunakan ketika membuat Card, dalam hal ini memposisikan widget tertentu misalnya iconbutton yang isinya heart diletakkan di ujung kanan atas card dan tanggal posting produk pada ujung kanan bawah.
- ListView
  Menampilkan daftar elemen secara vertikal atau horizontal yang dapat di-scroll. Berguna ketika menampilkan daftar yang panjang atau dinamis yang memungkinkan penggunaan widget seperti ListView.builder untuk mengoptimalkan performa. Saya biasa menggunakan listview builder untuk menampilkan widget-widget tampilan daftar dari list yang berisi objek dari model yang sama.
- GridView
  Menyusun elemen dalam bentuk grid yang terdiri dari baris dan kolom. Memungkinkan untuk menampilkan anak widget dalam posisi yang terstruktur dan dapat di-scroll secara horizontal atau vertikal. Saya biasanya menggunakan GridView untuk menampilkan sekumpulan Card dari list yang berisi objek dari model yang sama.
- Row
  Menyusun child-widget secara horizontal dari kiri ke kanan. Berguna untuk menyusun elemen-elemen secara berdampingan.Salah satu penggunaannya adalah menyusun Post Card yang mana figunakan untuk menyusun button like, dislike, dan share.
- Column
  Menyusun widget-child secara vertikal dari atas ke bawah. Cocok digunakan untuk tata letak berlapis yang membutuhkan susunan elemen secara berurutan. Salah satu contoh penggunaannya adalah untuk menyusun formulir. Kita memerlukan column untuk menyusun textformfield-textformfield secara vertikal 
- Wrap
  Mengatur child-widget secara horizontal atau vertikal sesuai dengan ukuran layar dan jika ruang tidak cukup, secara otomatis melanjutkan ke baris atau kolom berikutnya. Berguna untuk menata elemen-elemen yang ukurannya bervariasi atau tidak diketahui secara dinamis.Saya biasanya menggunakan Wrap untuk menampilkan daftar pencarian terpopuler di search page, hal tersebut karena wrap bisa menyesuaikan posisi child-widget agar sesuai dengan sisa space yang tersedia di layar. Selain itu, panjang teks daftar pencarian juga tidak selalu sama sehingga cocok menggunakan Wrap untuk membungkus daftar pencarian-pencarian.
3. TextFormField dengan type keyboard dan validasi tertentu untuk mendapatkan input string yang sesuai dari pengguna. Kemudian saya juga membuat custom widget untuk mengupload gambar, menampilkannya dan menghapusnya.

4. Penerapan clean architecture pada aplikasi Flutter adalah mengorganisir kode pada folder-folder tertentu sesuai fungsinya masing-masing. 
- File dart yang digunakan untuk membuat Model diletakkan di ``/models``
- File dart yang digunakan untuk membuat page diletakkan di ``/page``
- File dart yang berhubungan dengan HTTP Request ditempatkan di ``/api``
- File dart yang digunakan untuk menginisialisasi dan mengatur provider ditempatkan di ``/provider``
- File dart yang digunakan untuk membuat custom widget diletakkan di ``/component``
- File dart yang digunakan untuk autentikasi dan authorisasi diletakkan di ``/auth``
- File dart yang digunakan untuk utilitas diletakkan di ``/util``
Dengan pengelompokkan file-file yang sesuai pada masing-masing tempatnya, kode menjadi lebih mudah dipahami. Hal ini membantu kita tidak hanya dalam proyek individu, tetapi dalam proyek kelompok.
5. 
- Membuat halaman baru untuk menambahkan produk:
a. Buat  route di main:
```
class _AppState extends ConsumerState {
  void updateSocket (String token) {
    setSocket(token, ref);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>  LoginPage(updateSocketFunc: updateSocket,),
          '/register/set-photo': (context) => AddPhotoProfilePage(),
          '/register': (context) => const RegisterPage(),
          '/app': (context) => AppPage(key: UniqueKey(),),
          '/add-product': (context) => AddProductsPage(), // TAMBAHKAN INI
          '/all-your-products': (context) => AllYourProductPage() 
         },
      );
}}
```
b. Kemudian buat stateful widget seperti ini untuk page menambah produk di ``page/add_product_page.dart``:
```
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
```
Jangan lupa untuk menambahkan validator  dan button Save yang fungsional.
c. Tambahkan fungsionalitas button add item agar ketika ditekan bisa navigasi ke add product page:
```
 ElevatedButton(
                                   onPressed: () {
                                     Navigator.of(context).pushNamed('/add-product'); //TAMBAHKAN INI

                                     final snackBar = SnackBar(
                                       content: const Text('Kamu telah menekan tombol Tambah Item'),
                                       backgroundColor: Colors.blue,
                                       behavior: SnackBarBehavior.floating,
                                       action: SnackBarAction(
                                         label: 'Tutup',
                                         textColor: Colors.white,
                                         onPressed: () {
                                           // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                                         },


                                       ),
                                     );
                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     // Tambahkan aksi yang ingin dilakukan saat tombol "Tambah" ditekan

                                   },
                                   style: ElevatedButton.styleFrom(
                                     primary: Colors.blue, // Warna latar belakang tombol "Tambah"
                                     padding: EdgeInsets.all(8), // Padding tombol
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                     ),
                                   ),
                                   child: Text(
                                     'Tambah Item',
                                     style: TextStyle(
                                       fontSize: subtitleFontSize, // Ukuran teks
                                       color: Colors.white, // Warna teks
                                       fontWeight: FontWeight.bold, // Gaya teks
                                     ),
                                   ),
                                 ),
```
- Memunculkan data sesuai isi dari formulir yang diisi dalam sebuah pop-up setelah menekan tombol Save pada halaman formulir tambah item baru. 
a.Membuat Provider untuk menyimpan state produk saat ini:
```
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
final shopItemsProvider = StateNotifierProvider<ShopItemsNotifier, Map<String, ShopItem>>((ref) {
  return ShopItemsNotifier({});
});
final localItemsProvider = StateNotifierProvider<ShopItemsNotifier, Map<String, ShopItem>>((ref) {
  return ShopItemsNotifier({});
});
```
b. Mengatur websocket pada Django dengan menggunakan ASGI daphne dan redis.
c. Membuat client websocket di ``socket.dart`` di Flutter di mana ketika terdapat message yang berisi data produk baru maka perbarui state provider.
d. Hubungkan client websocket ketika aplikasi pertama kali load setelah login
```
import 'package:booking_app/api/socket.dart';
import 'package:booking_app/firebase_options.dart';
import 'package:booking_app/page/add_photo_profile_page.dart';
import 'package:booking_app/page/add_product_page.dart';
import 'package:booking_app/page/all_your_products_page.dart';
import 'package:booking_app/page/contents_page.dart';
import 'package:booking_app/page/login_page.dart';
import 'package:booking_app/page/register_page.dart';
import 'package:booking_app/page/your_products_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _AppState();
  }
}
class _AppState extends ConsumerState {
  void updateSocket (String token) {
    setSocket(token, ref);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>  LoginPage(updateSocketFunc: updateSocket,),
          '/register/set-photo': (context) => AddPhotoProfilePage(),
          '/register': (context) => const RegisterPage(),
          '/app': (context) => AppPage(key: UniqueKey(),),
          '/add-product': (context) => AddProductsPage(),
          '/all-your-products': (context) => AllYourProductPage()
         },
      );
}}
```
c. update socket setelah login di ``authentication.dart``:
```
Future<String?> login(String? username, String? password, context,WidgetRef? ref, Function updateSocket)async {
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
    if(ref != null){
      final userDataUrl = Uri.parse('$baseUrl/auth/get-user-data/');
      final userDataProvData = ref.watch(userDataProvider);
      final data = {
        'token': responseData['token']
      };
      final response = await http.post(
          userDataUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data)
      );
      final responseUserData = json.decode(response.body);
      print(responseUserData['user_profile']);
      final userProfile = responseUserData['user_profile'];
      UserData userData =
      UserData(id: userProfile['id'].toString(), username: userProfile['username'],
          fullName: userProfile['nama_lengkap'], profilePicture: userProfile['gambar_profil'],
          dateJoined:userProfile['date_joined'],
          email: userProfile['email'], description: userProfile['description'], alamat: userProfile['alamat'], nomorTelepon:
          userProfile['nomor_telepon']
      );
      ref.read(userDataProvider.notifier).setUserData(userData);
      await updateSocket(data['token']); // Update Socket
    }
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
```
```
import 'dart:convert';
import 'package:booking_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/models/shop_item.dart';
const baseUrl = '127.0.0.1:8000';
WebSocketChannel? channel;
bool reconnecting = false;

Future<void> setSocket(String token, WidgetRef ref) async {
  final wsUrl = Uri.parse('ws://$baseUrl/ws/products/$token/');
  channel = WebSocketChannel.connect(wsUrl);
  print("WebSocket connection established");
  channel!.stream.listen((message) {
    print('Received: $message');
    final messageData = jsonDecode(message);
    final messageType = messageData['type'];
    switch(messageType){
      case 'product.new_local':
        final ownerData = messageData['product_data']['pemilik'];
        final productData = messageData['product_data']['product'];
        final itemId = messageData['product_data']['product']['id_produk'];
        // update riverpod provider
        UserData owner = UserData.fromJson(ownerData);
        ShopItem item = ShopItem(itemId: itemId, itemData: productData, owner: owner);
        ref.read(localItemsProvider.notifier).addItem(item);


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
```
d. integrasikan Items provider tersebut dengan page ``your_products_page`` dan ``all_products_page``.
kodenya seperti ini di ``your_products_page``:
```
import 'package:booking_app/api/get_product_api.dart';
import 'package:booking_app/auth/authentication.dart';
import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/models/user.dart';
import 'package:booking_app/page/add_product_page.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/provider/user_provider.dart';
import 'package:booking_app/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/models/shop_item.dart';
import '../component/product_card.dart';
import 'yagitu.dart';
class MyProductPage extends ConsumerStatefulWidget{
  @override
  _MyProductPageState createState() {
    // TODO: implement createState
    return _MyProductPageState();
  }
}
class _MyProductPageState extends ConsumerState<MyProductPage> with TickerProviderStateMixin{

  bool _isFetched = false;
  double titleFontSize = TextSize.BASE.fontSize;
  double subtitleFontSize = TextSize.SM.fontSize;
  double contentFontSize = TextSize.XS.fontSize;
  double profilePictureSize = 30;
  double appBarHeight = 200;
  double kDistance = 12;
  double profileDistance = 20;
  late TabController _tabController;
  int _activeTabIndex = 0;

  Future<void> firstFetchData() async{
    final res = await getProducts(ref);
    if(res['message'] == 'SUCCESS'){
      final productsData = res['products'];
      final Map<String,ShopItem> items = {};
      for (final productData in productsData){
          UserData owner = UserData.fromJson(productData['pemilik']);
          ShopItem item = ShopItem(itemId: productData['product']['id_produk'],
              itemData: productData['product'], owner: owner);
          items[item.itemId] = item;
      }
      ref.read(localItemsProvider.notifier).setItems(items);
    }
    //ref.read(localItemsProvider);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Ganti `length` dengan jumlah tab yang Anda miliki.
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setResponsive(){
    final screenSize = getScreenSize(context);
    if(screenSize == ScreenSize.small){
      titleFontSize = TextSize.BASE.fontSize;
      subtitleFontSize = TextSize.SM.fontSize;
      contentFontSize = TextSize.XS.fontSize;
      profilePictureSize = 70;
      appBarHeight = 300;
      kDistance = 12;
      profileDistance = 20;
    }
    else if(screenSize == ScreenSize.medium){
      titleFontSize = TextSize.MD.fontSize;
      subtitleFontSize = TextSize.BASE.fontSize;
      contentFontSize = TextSize.SM.fontSize;
      profilePictureSize = 90;
      appBarHeight = 280;
      kDistance = 16;
      profileDistance = 40;
    }
    else{
      titleFontSize = TextSize.LG.fontSize;
      subtitleFontSize = TextSize.MD.fontSize;
      contentFontSize = TextSize.BASE.fontSize;
      profilePictureSize = 100;
      appBarHeight = 340;
      kDistance = 20;
      profileDistance = 60;
    }
  }
  void _handleTabSelection() {
    setState(() {
      _activeTabIndex = _tabController.index; // Memperbarui _activeTabIndex saat tab berubah
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userDataProvider); \\ TAMBAHKAN INI
    var myProduct = ref.watch(localItemsProvider); \\ TAMBAHKAN INI
    List<ShopItem>  productCards = myProduct.entries \\ TAMBAHKAN INI
        .map((entry) => entry.value)
        .toList().reversed.toList(); \\ TAMBAHKAN INI
    productCards = productCards.sublist(0,productCards.length > 6 ? 6 : productCards.length);
    setResponsive();
    print('ini username kamu: ');
    print(userData!.username);
    // TODO: implement build
    return CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
                
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue.shade700
                ),
                child:
                Center(
                  child: LayoutBuilder(builder:(context,constraints){
                    return Container(
                      width: constraints.maxWidth > 1024 ? 1024 : constraints.maxWidth,
                      height: appBarHeight,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 20),

                                child: Row(
                                  mainAxisAlignment:  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CircleAvatar(
                                      radius: profilePictureSize,
                                      backgroundImage: NetworkImage(
                                        userData!.profilePicture != null && !userData!.profilePicture!.isEmpty
                                            ? userData!.profilePicture!
                                            : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                      ),
                                    ),

                                    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                userData.fullName!,
                                                softWrap: false, // Tidak akan ada pemisahan baris
                                                overflow: TextOverflow.ellipsis, // Teks yang tidak muat akan ditampilkan dengan ellipsis (...)
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: titleFontSize, // Ukuran nama lengkap
                                                  fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                                                ),
                                              ),
                                              SizedBox(height: 8), // Jarak antara nama lengkap dan username
                                              Text(
                                                userData.username!,
                                                style: TextStyle(
                                                    fontSize: subtitleFontSize, // Ukuran username
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey.shade200// Gaya teks username
                                                ),
                                                softWrap: false, // Tidak akan ada pemisahan baris
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4,),
                                              Text(
                                                userData.email!,
                                                style: TextStyle(
                                                    fontSize: subtitleFontSize, // Ukuran email
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey.shade200// Gaya teks email
                                                ),
                                                maxLines: 2, // Tidak akan ada pemisahan baris
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )),
                                    if(getScreenSize(context) != ScreenSize.small) Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue, // Warna latar belakang tombol
                                            padding: EdgeInsets.all(12), // Padding tombol
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                            ),
                                          ),
                                          child: Text(
                                            'Manage Your Store',
                                            style: TextStyle(
                                              fontSize: subtitleFontSize, // Ukuran teks
                                              color: Colors.white, // Warna teks
                                              fontWeight: FontWeight.bold, // Gaya teks
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: kDistance,),
                                        ElevatedButton(
                                          onPressed: () {
                                            logout(ref, context);
                                            // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red, // Warna latar belakang tombol
                                            padding: EdgeInsets.all(12), // Padding tombol
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                            ),
                                          ),
                                          child: Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontSize: subtitleFontSize, // Ukuran teks
                                              color: Colors.white, // Warna teks
                                              fontWeight: FontWeight.bold, // Gaya teks
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: kDistance * 2),
                              if(getScreenSize(context) == ScreenSize.small) Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue, // Warna latar belakang tombol
                                      padding: EdgeInsets.all(12), // Padding tombol
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                      ),
                                    ),
                                    child: Text(
                                      'Manage Your Store',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize, // Ukuran teks
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold, // Gaya teks
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: kDistance,),
                                  ElevatedButton(
                                    onPressed: () {
                                      logout(ref, context);
                                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // Warna latar belakang tombol
                                      padding: EdgeInsets.all(12), // Padding tombol
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                      ),
                                    ),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize, // Ukuran teks
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold, // Gaya teks
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center ,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart, // Ikon keranjang belanja
                                            color: Colors.white, // Warna ikon
                                            size: subtitleFontSize, // Ukuran ikon
                                          ),
                                          SizedBox(width: 4,),
                                          Text('100', style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                        ],
                                      )
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center ,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_bag_rounded, // Ikon keranjang belanja
                                            color: Colors.white, // Warna ikon
                                            size: subtitleFontSize, // Ukuran ikon
                                          ),
                                          SizedBox(width: 4,),
                                          Text('100', style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                        ],
                                      )
                                    ],

                                  )),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center ,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star, // Ikon keranjang belanja
                                            color: Colors.yellowAccent, // Warna ikon
                                            size: subtitleFontSize, // Ukuran ikon
                                          ),
                                          SizedBox(width: 4,),
                                          Text('4.5', style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                        ],),
                                      SizedBox(height: 4,),
                                      Text('Dari 600 ulasan', style: TextStyle(fontSize: contentFontSize, fontWeight: FontWeight.normal, color: Colors.grey.shade200),)
                                    ],
                                  )),
                                ],
                              )
                            ],
                          )
                      ),
                    );
                  }),
                )
            ),
          )
          ,
          SliverAppBar(
              expandedHeight: 20,
              pinned: true,
              floating: true,
              snap: false,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: PreferredSize(
                preferredSize: Size(double.infinity, 4),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    isScrollable:true,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(
                        height: 24,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding:EdgeInsets.symmetric(horizontal: 12,),
                            color: _activeTabIndex == 0? Colors.lightBlue : Colors.grey.shade600, // Warna latar belakang tab
                            child: Center(
                              child: Text(
                                'As Seller',
                                style: TextStyle(fontSize: contentFontSize,color: Colors.white ), // Warna teks tab
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        height: 24,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            color: _activeTabIndex == 1? Colors.lightBlue : Colors.grey.shade600, // Warna latar belakang tab
                            child: Center(
                              child: Text(
                                'As Buyer',
                                style: TextStyle(fontSize: contentFontSize, color: Colors.white
                                ), // Warna teks tab
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Konten untuk penjual
                   LayoutBuilder(builder: (context,constraints){

                     return  Container(
                       alignment: Alignment.topCenter,
                       padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                       child: SingleChildScrollView(
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Text('Your Product', style: TextStyle(
                                     fontSize: titleFontSize,
                                     fontWeight: FontWeight.bold
                                 ),),
                                 Spacer(),
                                 ElevatedButton(
                                   onPressed: () {
                                     Navigator.of(context).pushNamed('/add-product');

                                     final snackBar = SnackBar(
                                       content: const Text('Kamu telah menekan tombol Tambah Item'),
                                       backgroundColor: Colors.blue,
                                       behavior: SnackBarBehavior.floating,
                                       action: SnackBarAction(
                                         label: 'Tutup',
                                         textColor: Colors.white,
                                         onPressed: () {
                                           // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                                         },


                                       ),
                                     );
                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     // Tambahkan aksi yang ingin dilakukan saat tombol "Tambah" ditekan

                                   },
                                   style: ElevatedButton.styleFrom(
                                     primary: Colors.blue, // Warna latar belakang tombol "Tambah"
                                     padding: EdgeInsets.all(8), // Padding tombol
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                     ),
                                   ),
                                   child: Text(
                                     'Tambah Item',
                                     style: TextStyle(
                                       fontSize: subtitleFontSize, // Ukuran teks
                                       color: Colors.white, // Warna teks
                                       fontWeight: FontWeight.bold, // Gaya teks
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   width: 8,
                                 ),

                                 ElevatedButton(
                                   onPressed: () {
                                     Navigator.of(context).pushNamed('/all-your-products');
                                     final snackBar = SnackBar(
                                       content: const Text('Kamu telah menekan tombol Lihat Item'),
                                       backgroundColor: Colors.green,
                                       behavior: SnackBarBehavior.floating,
                                       action: SnackBarAction(
                                         label: 'Tutup',
                                         textColor: Colors.white,
                                         onPressed: () {

                                           // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                                         },


                                       ),
                                     );
                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     // Tambahkan aksi yang ingin dilakukan saat tombol "Lihat Semua Daftar Produk" ditekan
                                   },
                                   style: ElevatedButton.styleFrom(
                                     primary: Colors.green, // Warna latar belakang tombol "Lihat Semua Daftar Produk"
                                     padding: EdgeInsets.all(8), // Padding tombol
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                     ),
                                   ),
                                   child: Text(
                                     'Lihat Item',
                                     style: TextStyle(
                                       fontSize: subtitleFontSize, // Ukuran teks
                                       color: Colors.white, // Warna teks
                                       fontWeight: FontWeight.bold, // Gaya teks
                                     ),
                                   ),
                                 )
                               ],
                             ),
                             SizedBox(height:20),
                             productCards.length != 0 ?GridView.builder( \\ Melakukan iterasi Produk
                               shrinkWrap: true,
                               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                 maxCrossAxisExtent: 300,
                                 crossAxisSpacing: 10,
                                 mainAxisSpacing: 10,
                                 childAspectRatio: 3/6,
                               ),
                               itemCount: productCards.length,
                               itemBuilder: (BuildContext context, int index) {
                                 // Tambahkan item-item Anda di sini
                                 return ProductCard(shopItem: productCards.elementAt(index));
                               },
                             ) : SizedBox(
                               height: MediaQuery.of(context).size.height * 0.32,
                               child: Center(
                                 child:  Text('Tidak ada data', style: TextStyle(
                                     fontSize: subtitleFontSize
                                 ),),
                               )
                             ),
                           ],
                         ),
                       ),
                     );
                   }),
                    // Konten untuk pelanggan
                    Expanded(child: Center(child: Text('Konten Sebagai Pelanggan')),)
                  ],
                ),
              ),

        ],
    );
  }
}
```
Untuk ``all_your_products_page``:
```
import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/models/shop_item.dart';

import '../component/product_card.dart';

class AllYourProductPage extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _AllYourProductPage();
  }
}
class _AllYourProductPage extends ConsumerState<AllYourProductPage>{
  String searchText = '';
  double titleFontSize = TextSize.BASE.fontSize;
  double subtitleFontSize = TextSize.SM.fontSize;
  double contentFontSize = TextSize.XS.fontSize;
  double profilePictureSize = 30;
  double appBarHeight = 200;
  double kDistance = 12;
  double profileDistance = 20;
  void setResponsive(){
    final screenSize = getScreenSize(context);
    if(screenSize == ScreenSize.small){
      titleFontSize = TextSize.BASE.fontSize;
      subtitleFontSize = TextSize.SM.fontSize;
      contentFontSize = TextSize.XS.fontSize;
      profilePictureSize = 70;
      appBarHeight = 300;
      kDistance = 12;
      profileDistance = 20;
    }
    else if(screenSize == ScreenSize.medium){
      titleFontSize = TextSize.MD.fontSize;
      subtitleFontSize = TextSize.BASE.fontSize;
      contentFontSize = TextSize.SM.fontSize;
      profilePictureSize = 90;
      appBarHeight = 280;
      kDistance = 16;
      profileDistance = 40;
    }
    else{
      titleFontSize = TextSize.LG.fontSize;
      subtitleFontSize = TextSize.MD.fontSize;
      contentFontSize = TextSize.BASE.fontSize;
      profilePictureSize = 100;
      appBarHeight = 340;
      kDistance = 20;
      profileDistance = 60;
    }
  }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(localItemsProvider); // Tambahkan ini
    List<ShopItem>  productCards = products.entries // Tambahkan ini
        .map((entry) => entry.value)
        .toList().reversed.toList();
    setResponsive();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Expanded(child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 768
                    ),
                    // 3/4 dari lebar AppBar
                    child: TextField(

                      onChanged: (text) {
                        // Ketika teks berubah, simpan ke dalam variabel searchText
                        setState(() {
                          searchText = text;
                        });
                      },

                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed:(){},icon: Icon(Icons.search),),
                        hintText: 'Cari barang Anda...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0), // Menentukan radius sudut
                        ),
                        fillColor: Colors.white, // Mengatur warna latar belakang
                        filled: true, // Mengaktifkan latar belakang
                      ),
                      textAlignVertical: TextAlignVertical.bottom,
                    ),
                  ),
                ),
              ),
              if(getScreenSize(context) != ScreenSize.small)
                Flexible(flex:1,child: Container()),
              IconButton(onPressed: (){
                Navigator.of(context).pushNamed('/add-product');
              }, icon: Icon(Icons.add_circle, size: 24,))
            ],
          ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: productCards.length != 0 ?GridView.builder( // Iterasi produk
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3/6,
              ),
              itemCount: productCards.length,
              itemBuilder: (BuildContext context, int index) {
                // Tambahkan item-item Anda di sini
                return ProductCard(shopItem: productCards.elementAt(index));
              },
            ) : SizedBox(
                height: MediaQuery.of(context).size.height * 0.32,
                child: Center(
                  child:  Text('Tidak ada data', style: TextStyle(
                      fontSize: subtitleFontSize
                  ),),
                )
            ),
          )
        ],
      ),
    );
  }
}
```
e. Buat permintaan HTTP untuk menambahkan produk ketika button save ditekan di ``add_product_page.dart``:
```
ElevatedButton(
                onPressed: (){
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0), // Sesuaikan nilai padding sesuai kebutuhan
                ),
                child: Text('Tambah Produk'),
              ),
```
```
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
      }
    }
  }
```
fungsi addProduct di ``/api/add_product_api.dart``:
```
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
```

Selesai, produk akan terupdate dengan otomatis.


TUGAS 7
1. Stateful widget adalah jenis widget yang memiliki state internal yang mana apabila data-data yang ada pada widget tersebut diubah di dalam  fungsi setState dan fungsi tersebut dijalankan maka widget ini akan merender ulang tampilannya termasuk tampilan anak-anak widgetnya.
Hal ini berbeda dengan Stateless widget, yang mana jenis widget yang tidak memiliki state internal sehingga tampilannya selalu sama sejak widget itu dibuat tidak peduli data di dalam widget tersebut berubah atau tidak.

2. widget yang saya gunakan:
- Snackbar itu  digunakan untuk menampilkan pesan sementara atau notifikasi kecil di bagian bawah layar.
- ElevatedButton digunakan untuk membuat tombol yang memiliki efek kenaikan (elevated) ketika ditekan.
- Column itu widget yang digunakan untuk mengatur anak-anak widget dalam satu garis vertikal(kolom).
- Scaffold itu digunakan sebagai kerangka utama untuk aplikasi Flutter. Fungsinya menyediakan tata letak umum untuk tampilan aplikasi, termasuk AppBar, Drawer, Floating Action Button, dan lain-lain.
- Text untuk menampilkan teks
- Container itu untuk membungkus anak widget dan menerapkan margin, padding, maupun decoration
- Center itu untuk meletakkan anak widget di tengah
3. Langkah-langkah:
a. Membuat projek Flutter yang diberi nama sesuai dengan keinginan, dalam hal ini sawarung.
b. Kemudian, karena saya membutuhkan package flutter riverpod, http, dan cached_network_image untuk kelanjutan tugas ini, maka saya mendaftarkan package-package tersebut ke pubspec.yaml .
c. Modifikasi main.dart. Tambahkan ProviderScope sebagai parent dari App. Kemudian kita perlu buat routing untuk App.
note: sebelumnya ide aplikasi saya booking app, tetapi saya ingin yang lebih mudah, jadinya sawarung saja.
```
import 'package:booking_app/page/contents_page.dart';
import 'package:booking_app/page/login_page.dart';
import 'package:booking_app/page/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const App()));

}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/app': (context) => AppPage()
      },
    );
  }
  }
```
d. Implementasi login dan register yang dikombinasikan dengan Django. Lalu buat provider untuk mengelola state token dan data user. Kemudian saya atur CORS agar aplikasi flutter ini bisa berinteraksi dengan django.
e. Setelah itu, di page/contents_page.dart, buat kode seperti ini
```
import 'package:booking_app/page/your_products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/provider/auth_provider.dart';

class AppPage extends ConsumerStatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  int _selectedIndex = 0; // Variabel untuk melacak indeks yang terpilih
  PageController _pageController = PageController(); // Deklarasi PageController

  @override
  void dispose() {
    _pageController.dispose(); // Pastikan untuk membebaskan sumber daya PageController saat widget di-dispose.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final auth = ref.watch(authNotifierProvider);
      if (auth.status == AuthStatus.unauthenticated) {
        print('kamu logout');
        // Jika belum terotentikasi, arahkan ke halaman login
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat halaman berubah
          });
        },
        children: <Widget>[
          Center(
            child: Text('Belum Dibuat'),
          ),
          Center(
            child: Text('Belum dibuat 2'),
          ),
          Center(
            child: Text('belum dibuat 3'),
          ),
          Center(
            child: Text('belum dibuat 4'),
          ),
          MyProductPage()
          // Tambahkan halaman lain sesuai kebutuhan
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Gunakan selectedIndex di sini
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat ikon di bottom navigation bar dipilih
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: _selectedIndex == 1 ? Colors.blue : Colors.grey,),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _selectedIndex == 2 ? Colors.blue : Colors.grey,),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _selectedIndex == 3 ? Colors.blue : Colors.grey,),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _selectedIndex == 4 ? Colors.blue : Colors.grey,),
            label: 'My Store',
          ),
        ],
        selectedItemColor: Colors.blue, // Warna teks label untuk item yang aktif
        unselectedItemColor: Colors.grey, // Warna teks label untuk item yang tidak aktif
      ),
    );
  }
}
```
e. Lalu ke page/your_products_page.dart , kita perlu membuat widget MyProductPage.
di page/your_products_page.dart buat kode seperti ini:
```
import 'package:booking_app/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/dummy/ShopItem.dart';
import 'yagitu.dart';
class MyProductPage extends ConsumerStatefulWidget{
  @override
  _MyProductPageState createState() {
    // TODO: implement createState
    return _MyProductPageState();
  }
}
class _MyProductPageState extends ConsumerState<MyProductPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(

          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue.shade700
          ),
          child:
           Center(
             child: LayoutBuilder(builder:(context,constraints){
               return Container(
                 width: constraints.maxWidth > 1024 ? 1024 : constraints.maxWidth,
                 height: 200,
                 child: Padding(
                     padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                     child: Column(
                       mainAxisSize: MainAxisSize.max,
                       children: [
                         Row(
                           mainAxisSize: MainAxisSize.max,
                           children: [
                             CircleAvatar(
                               maxRadius: 50,
                               minRadius: 20,
                               // Atur ukuran radius sesuai kebutuhan
                               backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'), // Gambar profil
                             ),
                             Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                             Flexible(
                               fit: FlexFit.tight,
                                 child: Container(

                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text(
                                     'Isa Citra Buana',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 20, // Ukuran nama lengkap
                                       fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                                     ),
                                   ),
                                   SizedBox(height: 8), // Jarak antara nama lengkap dan username
                                   Text(
                                     '@isa.citra',
                                     style: TextStyle(
                                         fontSize: 12, // Ukuran username
                                         fontWeight: FontWeight.normal,
                                         color: Colors.grey.shade200// Gaya teks username
                                     ),
                                   ),
                                   SizedBox(height: 4,),
                                   Text(
                                     'isacitralearning@gmail.com',
                                     style: TextStyle(
                                         fontSize: 12, // Ukuran email
                                         fontWeight: FontWeight.normal,
                                         color: Colors.grey.shade200// Gaya teks email
                                     ),
                                   ),
                                 ],
                               ),
                             )),
                             Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue, // Warna latar belakang tombol
                                      padding: EdgeInsets.all(8), // Padding tombol
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                      ),
                                    ),
                                    child: Text(
                                      'Manage Your Store',
                                      style: TextStyle(
                                        fontSize: 10, // Ukuran teks
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold, // Gaya teks
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      logout(ref, context);
                                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // Warna latar belakang tombol
                                      padding: EdgeInsets.all(8), // Padding tombol
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                      ),
                                    ),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 10, // Ukuran teks
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold, // Gaya teks
                                      ),
                                    ),
                                  )
                                ],
                              ),
                           ],
                         ),
                         Spacer(),
                         Row(
                           mainAxisSize: MainAxisSize.min,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Expanded(child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center ,
                               children: [
                                 Text('Jumlah Transaksi', style: TextStyle(fontSize: 12, color: Colors.white)),
                                 SizedBox(height: 4,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Icon(
                                       Icons.shopping_cart, // Ikon keranjang belanja
                                       color: Colors.white, // Warna ikon
                                       size: 24, // Ukuran ikon
                                     ),
                                     SizedBox(width: 4,),
                                     Text('100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                   ],
                                 )
                               ],
                             )),
                             Expanded(child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center ,
                               children: [
                                 Text('Jumlah Tipe Produk', style: TextStyle(fontSize: 12, color: Colors.white)),
                                 SizedBox(height: 4,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Icon(
                                       Icons.shopping_bag_rounded, // Ikon keranjang belanja
                                       color: Colors.white, // Warna ikon
                                       size: 24, // Ukuran ikon
                                     ),
                                     SizedBox(width: 4,),
                                     Text('100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                   ],
                                 )
                               ],

                             )),
                             Expanded(child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center ,

                               children: [
                                 Text('Rating', style: TextStyle(fontSize: 12, color: Colors.white)),
                                 SizedBox(height: 4,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Icon(
                                       Icons.star, // Ikon keranjang belanja
                                       color: Colors.yellowAccent, // Warna ikon
                                       size: 24, // Ukuran ikon
                                     ),
                                     SizedBox(width: 4,),
                                     Text('4.5', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                   ],),
                                 SizedBox(height: 4,),
                                 Text('Dari 600 ulasan', style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal, color: Colors.grey.shade200),)
                               ],
                             )),
                           ],
                         )
                       ],
                     )
                 ),
               );
             }),
           )
          ),
        Expanded(child: LayoutBuilder(builder: (context, constraints){
          return Container(
              width:  constraints.maxWidth > 1024 ? 1024 : constraints.maxWidth ,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Kamu telah menekan tombol Tambah Item'),
                            backgroundColor: Colors.blue,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Tutup',
                              textColor: Colors.white,
                              onPressed: () {
                                // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                              },


                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Tambahkan aksi yang ingin dilakukan saat tombol "Tambah" ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Warna latar belakang tombol "Tambah"
                          padding: EdgeInsets.all(8), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                          ),
                        ),
                        child: Text(
                          'Tambah Item',
                          style: TextStyle(
                            fontSize: 10, // Ukuran teks
                            color: Colors.white, // Warna teks
                            fontWeight: FontWeight.bold, // Gaya teks
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Kamu telah menekan tombol Lihat Item'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Tutup',
                              textColor: Colors.white,
                              onPressed: () {
                                // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                              },


                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Tambahkan aksi yang ingin dilakukan saat tombol "Lihat Semua Daftar Produk" ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Warna latar belakang tombol "Lihat Semua Daftar Produk"
                          padding: EdgeInsets.all(8), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                          ),
                        ),
                        child: Text(
                          'Lihat Item',
                          style: TextStyle(
                            fontSize: 10, // Ukuran teks
                            color: Colors.white, // Warna teks
                            fontWeight: FontWeight.bold, // Gaya teks
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: items.map((e) => ShopItemWidget(item: e, onSelectedMeal: (str) => {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                          // Return halaman baru yang ingin ditampilkan
                          return AAAA();
                          }),
                          )
                          })).toList(),
                        ),
                      )
                  )

                ],
              )
          );
        }))
      ],
    );
  }
}
```
Pada button Lihat Item:
```
ElevatedButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Kamu telah menekan tombol Lihat Item'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Tutup',
                              textColor: Colors.white,
                              onPressed: () {
                                // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                              },


                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Tambahkan aksi yang ingin dilakukan saat tombol "Lihat Semua Daftar Produk" ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Warna latar belakang tombol "Lihat Semua Daftar Produk"
                          padding: EdgeInsets.all(8), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                          ),
                        ),
                        child: Text(
                          'Lihat Item',
                          style: TextStyle(
                            fontSize: 10, // Ukuran teks
                            color: Colors.white, // Warna teks
                            fontWeight: FontWeight.bold, // Gaya teks
                          ),
                        ),
                      )
```
pada button Tambah Item:
```
 ElevatedButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Kamu telah menekan tombol Tambah Item'),
                            backgroundColor: Colors.blue,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Tutup',
                              textColor: Colors.white,
                              onPressed: () {
                                // Tindakan yang akan diambil ketika tombol "Tutup" pada Snackbar ditekan.
                              },


                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Tambahkan aksi yang ingin dilakukan saat tombol "Tambah" ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Warna latar belakang tombol "Tambah"
                          padding: EdgeInsets.all(8), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                          ),
                        ),
                        child: Text(
                          'Tambah Item',
                          style: TextStyle(
                            fontSize: 10, // Ukuran teks
                            color: Colors.white, // Warna teks
                            fontWeight: FontWeight.bold, // Gaya teks
                          ),
                        ),
                      ),
```
Pada button logout:
```
ElevatedButton(
                                    onPressed: () {
                                      logout(ref, context);
                                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // Warna latar belakang tombol
                                      padding: EdgeInsets.all(8), // Padding tombol
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                      ),
                                    ),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 10, // Ukuran teks
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold, // Gaya teks
                                      ),
                                    ),
                                  )
```
Sementara fungsi logout itu yang berada di auth/authentication.dart sebagai berikut:
```
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
```