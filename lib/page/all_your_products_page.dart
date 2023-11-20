import 'package:booking_app/models/responsive.dart';
import 'package:booking_app/provider/items_provider.dart';
import 'package:booking_app/provider/user_provider.dart';
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
    final products = ref.watch(shopItemProviders);
    final userData = ref.watch(userDataProvider);
    List<ShopItem>  productCards = products.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => element.owner.id == userData!.id ).toList();
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
            child: productCards.length != 0 ?GridView.builder(
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