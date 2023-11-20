import 'dart:math';

import 'package:booking_app/component/category_button.dart';
import 'package:booking_app/models/category.dart';
import 'package:booking_app/page/product_detail_page.dart';
import 'package:booking_app/util/storage_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/util/responsive.dart';

import '../component/product_card.dart';
import '../models/shop_item.dart';
import '../provider/items_provider.dart';
import '../provider/user_provider.dart';

class Home extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends ConsumerState<Home>{
  ResponsiveValue responsiveValue = ResponsiveValue();
  CarouselController _carouselController = CarouselController();
  List<ShopItem>? currCarouselItems;
  bool getRecommended = false;


  List<ShopItem> takeFiveRandomSamples(List<ShopItem> list) {
    Random random = Random();
    List<ShopItem> resultList = List.from(list);
    // Clone list to avoid modifying original list

    if (resultList.length <= 5) {
      return resultList;
    }

    resultList.shuffle(random);
    return resultList.sublist(0, 5);
  }
  @override
  Widget build(BuildContext context) {
    double _carouselHeight = getScreenSize(context) == ScreenSize.small ?250 :
    getScreenSize(context) == ScreenSize.medium ? 280 :300;
    var userData = ref.watch(userDataProvider);
    var myProduct = ref.watch(shopItemProviders);
    List<ShopItem>  productCards = myProduct.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => true).toList();
    // TODO: implement build
    responsiveValue.setResponsive(context);
    currCarouselItems = takeFiveRandomSamples(productCards);

    print('mana sih woiiii ${currCarouselItems!.length}');
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.indigoAccent.shade400,
            child: CarouselSlider(
              carouselController: _carouselController ,
              options: CarouselOptions(
                viewportFraction: 1,
                height: _carouselHeight
              ),
              items: [
                ...currCarouselItems!.map((shopItem){
                  return Container(
                    padding: EdgeInsets.all(16),
                    height: _carouselHeight,
                    constraints: BoxConstraints(
                      maxWidth: 768
                    ),
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: _carouselHeight-50,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                      aspectRatio: 3/4,
                                      child: Image.network(shopItem.itemData['gambar'][0].toString(), fit: BoxFit.cover,),
                                    ),
                                  ),
                                  Positioned(
                                      left: 8,
                                      top: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade400,
                                          borderRadius: BorderRadius.circular(5),

                                        ),
                                        child: Align(
                                          child: Text('Rp ${shopItem.itemData['harga'].replaceAll(RegExp(r"(\.[0]*$)"), "")}',
                                            style: TextStyle(
                                                color: Colors.white
                                            ),),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(width: 16,),
                            Expanded(child: SizedBox(
                                height: _carouselHeight-50,
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${shopItem.itemData['nama']}', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                          fontSize: responsiveValue.titleFontSize),),
                                      SizedBox(height: 8,),
                                      Expanded(child: Row(
                                        children: [Flexible(child: Text('${shopItem.itemData['deskripsi']}', textAlign: TextAlign.justify, style: TextStyle(color: Colors.white,
                                          fontSize: responsiveValue.contentFontSize, ), overflow: TextOverflow.ellipsis, ),),],
                                      ),),
                                      SizedBox(height: 8,),
                                      Spacer(),
                                      ElevatedButton(onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                          return ProductDetailPage(productId: shopItem.itemId,);
                                        }));
                                      }, style:
                                      ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)), child:Text('Lihat Produk', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                          fontSize: responsiveValue.titleFontSize),) )

                                    ],
                                  ),
                                )),)
                          ],
                        ))
                      ],
                    ),

                  );
                }).toList()
              ],
            ) ,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            child: Column(

            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(16),
            height: getScreenSize(context) == ScreenSize.small? 126 :
            getScreenSize(context) == ScreenSize.medium? 139  : 146,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                CategoryBtn(function: (){}, icon: Icons.border_all_rounded, name: 'Lihat Semua'),
                ...ProductCategory.values.map((e) => CategoryBtn(function: (){}, icon:  e.iconData, name: e.stringValue)).toList()
                ,//SizedBox(height: 8,)
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spesial di Sawarung hari ini',
                  maxLines: 2,
                  style: TextStyle(
                  color: Colors.black,
                    fontSize: responsiveValue.titleFontSize,
                    fontWeight: FontWeight.bold

                ),),
                SizedBox(height: 8,),
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
                          fontSize: responsiveValue.subtitleFontSize
                      ),),
                    )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

