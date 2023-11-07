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