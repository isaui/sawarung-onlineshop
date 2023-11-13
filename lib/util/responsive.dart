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