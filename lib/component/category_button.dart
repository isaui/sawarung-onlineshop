import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/responsive.dart';

class CategoryBtn extends StatelessWidget{
  final Function function;
  final IconData icon;
  final String name;
  final ResponsiveValue responsiveValue = ResponsiveValue();
  CategoryBtn({required this.function, required this.icon, required this.name});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    responsiveValue.setResponsive(context);
    return  GestureDetector(
      onTap: (){
        function();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigoAccent.shade400,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(icon, color: Colors.white, size: responsiveValue.extraTitleFontSize + 16,),
            ),
            SizedBox(height: 8,),
            Text(name, overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(
              fontSize: responsiveValue.contentFontSize
            ),)
          ],
        ),
      ),
    );
  }
}