import 'package:booking_app/api/get_product_api.dart';
import 'package:booking_app/auth/authentication.dart';
import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/models/user.dart';
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
    var userData = ref.watch(userDataProvider);
    var myProduct = ref.watch(localItemsProvider);
    List<ShopItem>  productCards = myProduct.entries
        .map((entry) => entry.value)
        .toList().reversed.toList();
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
                             productCards.length != 0 ?GridView.builder(
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