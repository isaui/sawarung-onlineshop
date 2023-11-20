import 'package:booking_app/models/responsive.dart';
import 'package:flutter/material.dart';
ScreenSize getScreenSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 768) {
    return ScreenSize.small;
  } else if (screenWidth < 1024) {
    return ScreenSize.medium;
  } else {
    return ScreenSize.large;
  }
}

class ResponsiveValue{
  double extraTitleFontSize = TextSize.MD.fontSize;
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
      extraTitleFontSize = TextSize.MD.fontSize;
      subtitleFontSize = TextSize.SM.fontSize;
      contentFontSize = TextSize.XS.fontSize;
      profilePictureSize = 70;
      appBarHeight = 300;
      kDistance = 12;
      profileDistance = 20;
    }
    else if(screenSize == ScreenSize.medium){
      titleFontSize = TextSize.MD.fontSize;
      extraTitleFontSize = TextSize.LG.fontSize;
      subtitleFontSize = TextSize.BASE.fontSize;
      contentFontSize = TextSize.SM.fontSize;
      profilePictureSize = 90;
      appBarHeight = 280;
      kDistance = 16;
      profileDistance = 40;
    }
    else{
      extraTitleFontSize = TextSize.XL.fontSize;
      titleFontSize = TextSize.LG.fontSize;
      subtitleFontSize = TextSize.MD.fontSize;
      contentFontSize = TextSize.BASE.fontSize;
      profilePictureSize = 100;
      appBarHeight = 340;
      kDistance = 20;
      profileDistance = 60;
    }
  }
}