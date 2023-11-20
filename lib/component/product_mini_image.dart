import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductMiniImage extends StatelessWidget {
  final String imageData;
  final Function function;
  final bool isSelected;

  const ProductMiniImage({super.key, required this.imageData, required this.isSelected, required this.function});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: (){
            function();
          },
          child: Container(
            decoration: isSelected ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.indigoAccent.shade400,
              ),
            ) : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            height: constraints.maxHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.network(imageData, fit: BoxFit.cover),
              ),
            ),
          ),
        );

      },
    );
  }
}
