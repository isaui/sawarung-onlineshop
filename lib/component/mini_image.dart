import 'dart:typed_data';
import 'package:flutter/material.dart';

class MiniImage extends StatelessWidget {
  final Uint8List imageData;
  final Function function;

  const MiniImage({super.key, required this.imageData, required this.function});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
           child: Stack(
              children: [
                AspectRatio(
                    aspectRatio: 3/4,
                    child: Image.memory(imageData, fit: BoxFit.cover),
                  ),
                Positioned(
                  top: 4.0,
                  right: -20,
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: () {function();},
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                        ),
                        shape: CircleBorder(),
                      ),
                    )
                  )
                ),
              ],
            )
        );
      },
    );
  }
}
