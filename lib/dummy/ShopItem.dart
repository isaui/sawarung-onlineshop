import 'package:flutter/material.dart';
const List<String> dummyPictures = [
  'https://res.cloudinary.com/dk0z4ums3/image/upload/v1661753020/attached_image/inilah-cara-merawat-anak-kucing-yang-tepat.jpg',
  'https://awsimages.detik.net.id/community/media/visual/2021/07/19/sapi-limosin.jpeg?w=600&q=90'
];
List<ShopItem> items = [
  new ShopItem(name: 'Kucing', price: 50000, image: dummyPictures[0]),
  new ShopItem(name: 'Sapi', price: 150000, image: dummyPictures[1]),
];
class ShopItem{
  final String name;
  final int price;
  final String image;
  const ShopItem({required this.name, required this.price, required this.image});
}

class ShopItemWidget extends StatelessWidget {
  final ShopItem item;
  final onSelectedMeal;
  const ShopItemWidget({required this.item, required this.onSelectedMeal});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          onSelectedMeal(item.name);
        },
        child: Stack(
          children: [
            Image.network(
              item.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 6, horizontal: 14),
                color: Colors.black54,
                child: Column(
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tambahkan widget lain di sini jika diperlukan
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}