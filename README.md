# Sawarung - Warung Online
Projek Sawarung adalah aplikasi warung online yang revolusioner. Dibangun dengan teknologi flutter dan django, Sawarung memungkinkan pengguna untuk memesan makanan, minuman, dan barang-barang sehari-hari dari orang lain atau warung-warung lokal favorit mereka dengan mudah melalui aplikasi seluler atau situs web. Jual beli easy, ga perlu buat toko, semua bisa pakai!

## Tugas Flutter
Nama: Isa Citra Buana
NPM: 2206081465
Kelas: PBP D

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