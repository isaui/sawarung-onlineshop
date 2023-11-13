import 'package:booking_app/util/time.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/shop_item.dart';

import '../models/responsive.dart';
import '../util/responsive.dart';
class ProductCard extends StatelessWidget {
  final ShopItem shopItem;
   ProductCard({
     required this.shopItem,
  });
  double titleFontSize = TextSize.BASE.fontSize;
  double subtitleFontSize = TextSize.SM.fontSize;
  double contentFontSize = TextSize.XS.fontSize;
  double profilePictureSize = 30;
  double appBarHeight = 200;
  double kDistance = 12;
  double profileDistance = 20;

  void setResponsive(context){
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
    setResponsive(context);
    return Card(
      color: Colors.white70,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 0.8,
                child: Image.network(
                  shopItem.itemData['gambar'][0],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopItem.itemData['nama'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(shopItem.owner.profilePicture != null? shopItem.owner.profilePicture!.isNotEmpty?
                              shopItem.owner.profilePicture!:  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png':
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                          radius: subtitleFontSize, // Sesuaikan dengan ukuran yang Anda inginkan
                        ),
                        SizedBox(width: 8), // Beri jarak antara gambar profil dan teks
                        Flexible(
                          child: Text(
                            '${shopItem.owner.fullName}',
                            maxLines: getScreenSize(context) == ScreenSize.small?1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: contentFontSize,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),

                      ],

                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 12, bottom: 12),
                          child: Text(

                            'Belum ada ulasan',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: contentFontSize,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: Text(

                      'Rp ${shopItem.itemData['harga'].replaceAll(RegExp(r"(\.[0]*$)"), "")}',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.indigoAccent.shade400,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                  Padding(padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          Text(

                            '${formatTimeAgo(shopItem.itemData['created_at'])}',
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: contentFontSize,
                            ),
                          )
                        ],
                      ))
                ],
              )

            ],
          ),
    );

  }
}