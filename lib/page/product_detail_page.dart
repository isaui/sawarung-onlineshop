import 'package:booking_app/component/expandable_text.dart';
import 'package:booking_app/component/product_appbar.dart';
import 'package:booking_app/component/product_card.dart';
import 'package:booking_app/component/product_mini_image_container.dart';
import 'package:booking_app/component/review_widget.dart';
import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/models/shop_item.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/util/responsive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends ConsumerStatefulWidget{
  final String productId;
  ProductDetailPage({required this.productId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _ProductDetailPageState();
  }
}
class _ProductDetailPageState extends ConsumerState<ProductDetailPage>{

  final responsiveValue = ResponsiveValue();
  int _currentIndex = 0;
  CarouselController controller = CarouselController();
  bool _isColoredAppBar = false;

  @override
  Widget build(BuildContext context) {
    final productId = widget.productId;
    final items = ref.watch(shopItemProviders);
    final pickItem = items[productId];
    final anotherItems = items.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => element.owner.id == pickItem!.owner.id && element.itemId != pickItem!.itemId ).toList();
    final anotherPickedItems = anotherItems.sublist(0, anotherItems.length < 6 ? anotherItems.length : 6);

    double _carouselHeight = getScreenSize(context) == ScreenSize.small ?250 :
    getScreenSize(context) == ScreenSize.medium ? 280 :300;

    print(pickItem!.itemData['gambar']);
    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ProductAppBar(changeColor:_isColoredAppBar),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.chat_rounded, color: Colors.blue,)),
              SizedBox(width: 8,),
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(8) ,
                    side: BorderSide(color: Colors.blue),),
                onPressed: (){},
                child: Text('Beli', style: TextStyle(color: Colors.blue, fontSize: responsiveValue.subtitleFontSize),),
              )),
              SizedBox(width: 8,),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(8)
                ),
                onPressed: (){},
                child: Text('+ Keranjang', style: TextStyle(color: Colors.white, fontSize: responsiveValue.subtitleFontSize),),

              ),
              ),
              SizedBox(width: 8,),

            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.metrics.axis == Axis.vertical) {
            // Hitung posisi scroll terkini
            final pixels = scrollNotification.metrics.pixels;

            // Cek apakah Carousel sudah terscroll keluar layar
            setState(() {
              _isColoredAppBar = pixels >= _carouselHeight;
            });
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CarouselSlider(
                      carouselController: controller,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          height: getScreenSize(context) == ScreenSize.small ?250 :
                          getScreenSize(context) == ScreenSize.medium ? 280 :300 ,
                          onPageChanged: (index, reason){
                            setState(() {
                              _currentIndex = index;
                            });
                          }

                      ),
                      items: [
                        ...pickItem!.itemData['gambar'].map((image){
                          return Container(
                              color: Colors.black,
                              child: Align(
                                  child: AspectRatio(
                                    aspectRatio: 4/4,
                                    child: Image.network(image, fit: BoxFit.cover,),
                                  )
                              )
                          );
                        }).toList()
                      ],
                    ),
                    Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.shade400,
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: Align(
                            child: Text('${pickItem!.itemData['dijual']? 'For Sale' : 'Not For Sale'}',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        )),
                    Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.shade400,
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: Align(
                            child: Text('${_currentIndex+1}/${pickItem.itemData['gambar'].length}',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        ))
                  ],
                )
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${pickItem!.itemData['nama']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsiveValue.titleFontSize,
                                  fontWeight: FontWeight.bold

                              ),

                            ),
                            SizedBox(height: 4,),
                            Text('Rp${pickItem!.itemData['harga'].replaceAll(RegExp(r"(\.[0]*$)"), "")}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.indigoAccent.shade400,
                                fontSize: responsiveValue.extraTitleFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            ),
                          ],
                        )),
                        SizedBox(width: 8,),
                        IconButton(onPressed: (){}, icon: Icon(Icons.favorite, color: Colors.grey.shade400, size:
                        responsiveValue.titleFontSize + 12,))
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Belum Terjual', style: TextStyle(
                            fontSize: responsiveValue.contentFontSize
                        ),),
                        SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.indigoAccent
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Align(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow,),
                                  Text('4.8', style: TextStyle(fontSize: responsiveValue.contentFontSize),),
                                  Text(' (105)', style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: responsiveValue.contentFontSize
                                  ),),

                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 8,),
                        if(MediaQuery.of(context).size.width > 300 ) Builder(builder: (context){
                          int stock = int.tryParse(pickItem!.itemData['stok'] ?? '0') ?? 0;

                          return  Text(
                            'Sisa $stock stok ${stock > 20 ? '' : 'aja!'}',
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: responsiveValue.contentFontSize,
                            ),
                          );
                        })
                      ],
                    ),
                    if(MediaQuery.of(context).size.width <= 300)Builder(builder: (context){
                      int stock = int.tryParse(pickItem!.itemData['stok'] ?? '0') ?? 0;

                      return  Container(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Sisa $stock stok ${stock > 20 ? '' : 'aja!'}',
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: responsiveValue.contentFontSize,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 8,),
                    Text('Gambar', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    LayoutBuilder(builder: (context,constraint){
                      return Container(
                        height: 120,
                        width: constraint.maxWidth,
                        child: ProductMiniImageContainer(currIndex: _currentIndex, function: (index){
                          setState(() {
                            _currentIndex = index;
                          });
                          controller.animateToPage(index);
                        }, imagesData: pickItem!.itemData['gambar'].cast<String>())
                        ,
                      );
                    }),
                    SizedBox(height: 8,),
                    Text('Deskripsi', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    ExpandableDescription(text: pickItem!.itemData['deskripsi'], maxLines: 5,),
                    SizedBox(height: 8,),
                    Text('Kategori', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 4,
                      runSpacing: 6,
                      children: [
                        ...pickItem!.itemData['kategori'].cast<String>().map((kategori){
                          return ElevatedButton(onPressed: (){}, child: Text('$kategori'));
                        }).toList()
                      ],
                    ),

                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Review', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: responsiveValue.titleFontSize),),
                        Text('Show All', textAlign: TextAlign.left, style: TextStyle(color: Colors.black,
                            fontSize: responsiveValue.subtitleFontSize),),
                      ],
                    ),
                    SizedBox(height: 4,),
                    ReviewsWidget(),
                    SizedBox(height: 8,),
                    Text('Penjual', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    Container(
                      child: LayoutBuilder(
                        builder: (context, constraints){
                          return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.indigoAccent.shade400)
                              ),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width > 300 ? responsiveValue.profilePictureSize : 40,
                                        backgroundImage: NetworkImage(
                                          pickItem!.owner.profilePicture != null && !pickItem!.owner!.profilePicture!.isEmpty
                                              ? pickItem!.owner!.profilePicture!
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
                                                  pickItem!.owner.fullName!,
                                                  softWrap: false, // Tidak akan ada pemisahan baris
                                                  overflow: TextOverflow.ellipsis, // Teks yang tidak muat akan ditampilkan dengan ellipsis (...)
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.titleFontSize, // Ukuran nama lengkap
                                                    fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                                                  ),
                                                ),
                                                SizedBox(height: 8), // Jarak antara nama lengkap dan username
                                                Text(
                                                  pickItem!.owner.username!,
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.subtitleFontSize, // Ukuran username
                                                    fontWeight: FontWeight.normal,

                                                  ),
                                                  softWrap: false, // Tidak akan ada pemisahan baris
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4,),
                                                Text(
                                                  pickItem!.owner.email!,
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.subtitleFontSize, // Ukuran email
                                                    fontWeight: FontWeight.normal,

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
                                              'Visit Profile',
                                              style: TextStyle(
                                                fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                                color: Colors.white, // Warna teks
                                                fontWeight: FontWeight.bold, // Gaya teks
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: responsiveValue.kDistance,),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: responsiveValue.kDistance * 2),
                                  if(getScreenSize(context) == ScreenSize.small) Row(
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
                                          'Visit Profile',
                                          style: TextStyle(
                                            fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                            color: Colors.white, // Warna teks
                                            fontWeight: FontWeight.bold, // Gaya teks
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: responsiveValue.kDistance,),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  if(anotherPickedItems.length > 0) Divider(thickness: 1, color: Colors.indigoAccent,),
                                  if(anotherPickedItems.length > 0)Text('Produk lain dari penjual ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontSize: responsiveValue.subtitleFontSize),),
                                  if(anotherPickedItems.length > 0)SizedBox(height: 8,),
                                  if(anotherPickedItems.length > 0)LayoutBuilder(builder: (ctx, cs){
                                    return SizedBox(
                                      width: cs.maxWidth,
                                      height: (getScreenSize(context) == ScreenSize.small? 200 :
                                      getScreenSize(context)  == ScreenSize.medium? 220 : 240) *2 + 25,
                                      child: anotherPickedItems.length > 0 ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: anotherPickedItems.length ,
                                        itemBuilder: (BuildContext context, int index) {
                                          return SizedBox(
                                            width: getScreenSize(context) == ScreenSize.small? 200 :
                                            getScreenSize(context)  == ScreenSize.medium? 220 : 240,
                                            child: ProductCard(shopItem: anotherPickedItems[index]),
                                          );
                                        },
                                      ) : Center(
                                        child:
                                        Text('Tidak ada barang lain dari seller ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black,
                                            fontSize: responsiveValue.contentFontSize),),
                                      ),
                                    );
                                  })
                                ],
                              )
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}