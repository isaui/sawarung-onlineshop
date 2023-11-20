import 'dart:html';

import 'package:booking_app/component/drawer.dart';
import 'package:booking_app/page/home.dart';
import 'package:booking_app/page/your_products_page.dart';
import 'package:booking_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booking_app/provider/auth_provider.dart';

import '../api/get_product_api.dart';
import '../models/responsive.dart';
import '../models/shop_item.dart';
import '../models/user.dart';
import '../provider/items_provider.dart';
import '../util/global_key.dart';
import '../util/responsive.dart';

class AppPage extends ConsumerStatefulWidget {
  final initialIndex;
  AppPage({super.key, this.initialIndex = 0});
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  int _selectedIndex = 0; // Variabel untuk melacak indeks yang terpilih
  bool _firstFetched = false;
  PageController _pageController = PageController();
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
      ref.read(shopItemProviders.notifier).setItems(items);
      _firstFetched = true;
    }
    //ref.read(localItemsProvider);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if( !_firstFetched){
        firstFetchData();
      }
    });
    print(widget.initialIndex);
   WidgetsBinding.instance.addPostFrameCallback((_) async {
     setState(() {
       _selectedIndex = widget.initialIndex;
       _pageController.animateToPage(
         _selectedIndex,
         duration: Duration(milliseconds: 300),
         curve: Curves.easeInOut,
       );
     });
   });
  }
  @override
  void dispose() {
    _pageController.dispose(); // Pastikan untuk membebaskan sumber daya PageController saat widget di-dispose.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    setResponsive();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final auth = ref.watch(authNotifierProvider);
      if (auth.status == AuthStatus.unauthenticated) {
        print('kamu logout');
        // Jika belum terotentikasi, arahkan ke halaman login
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: _selectedIndex == 4? Colors.blue.shade700 : Colors.transparent, // Atur latar belakang menjadi transparan
        elevation: 0, // Hilangkan bayangan/app shadow
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: _selectedIndex == 4? Colors.white : Colors.black), // Atur warna ikon hamburger
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Tindakan ketika hamburger diklik
              },
            );
          },
        ),
        actions: [
          if(_selectedIndex == 0)IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined, color: Colors.black,),),
          if(_selectedIndex == 0)IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined, color: Colors.black,),),
          if(_selectedIndex == 0)IconButton(onPressed: (){}, icon: Icon(Icons.settings, color: Colors.black,),),
        ],
      ),
      drawer: MyDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat halaman berubah
          });
        },
        children: <Widget>[
          Home(),
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