import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductAppBar extends ConsumerWidget implements PreferredSizeWidget{
  final preferredSize;
  final bool changeColor;
  ProductAppBar({required this.changeColor}) : preferredSize = Size.fromHeight(kToolbarHeight), super();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return AppBar(
      backgroundColor: changeColor? Colors.blue : Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined, ),),
        IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined),),
      ],
    );
  }
}