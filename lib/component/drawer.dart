import 'package:booking_app/page/contents_page.dart';
import 'package:booking_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/authentication.dart';
import '../models/responsive.dart';
import '../util/responsive.dart';

class MyDrawer extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyDrawerState();
  }
}

class _MyDrawerState extends ConsumerState<MyDrawer>{
  double titleFontSize = TextSize.BASE.fontSize;
  double subtitleFontSize = TextSize.SM.fontSize;
  double contentFontSize = TextSize.XS.fontSize;
  double profilePictureSize = 30;
  double appBarHeight = 250;
  double kDistance = 12;
  double profileDistance = 20;
  void setResponsive(){
    final screenSize = getScreenSize(context);
    if(screenSize == ScreenSize.small){
      titleFontSize = TextSize.BASE.fontSize;
      subtitleFontSize = TextSize.SM.fontSize;
      contentFontSize = TextSize.XS.fontSize;
      profilePictureSize = 70;
      appBarHeight = 250;
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
    final userData = ref.watch(userDataProvider);
    setResponsive();
    // TODO: implement build
    return Drawer(
      child: Column(
        children: [
          Container(
            height: appBarHeight,
            color: Colors.blue.shade700,
            padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: profilePictureSize * 0.8,
                      backgroundImage: NetworkImage(
                        userData!.profilePicture != null && !userData!.profilePicture!.isEmpty
                            ? userData!.profilePicture!
                            : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
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
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@'+userData.username!,
                      style: TextStyle(
                          fontSize: subtitleFontSize, // Ukuran username
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade200// Gaya teks username
                      ),
                      softWrap: false, // Tidak akan ada pemisahan baris
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: subtitleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Your Store',
                        style: TextStyle(
                          fontSize: subtitleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home), // Ikon untuk halaman utama
            title: Text('Halaman Utama', style: TextStyle(fontSize: subtitleFontSize),),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return AppPage(key: UniqueKey(),initialIndex: 4, );

              }));
              // Tindakan ketika ListTile Halaman Utama diklik
              // Misalnya: Navigasi ke halaman utama
            },
          ),
          // ListTile untuk menambah item
          ListTile(
            leading: Icon(Icons.add), // Ikon untuk menambah item
            title: Text('Tambah Item', style: TextStyle(fontSize: subtitleFontSize)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed('/add-product');
              // Tindakan ketika ListTile Tambah Item diklik
              // Misalnya: Navigasi ke halaman tambah item
            },
          ),
          Spacer(),
          Container(
            child: Row(
              children: [
                Flexible(child: ListTile(
                  leading: Icon(Icons.settings), // Ikon untuk halaman utama
                  title: Text('Setting', style: TextStyle(fontSize: subtitleFontSize),),
                  onTap: () {
                    // Tindakan ketika ListTile Halaman Utama diklik
                    // Misalnya: Navigasi ke halaman utama
                  },
                ),),
                Flexible(child: ListTile(
                  leading: Icon(Icons.logout), // Ikon untuk halaman utama
                  title: Text('Logout', style: TextStyle(fontSize: subtitleFontSize),),
                  onTap: () {
                    logout(ref, context);
                    // Tindakan ketika ListTile Halaman Utama diklik
                    // Misalnya: Navigasi ke halaman utama
                  },
                ),)
              ],
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}