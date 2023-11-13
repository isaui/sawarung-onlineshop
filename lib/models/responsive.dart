enum ScreenSize { small, medium, large }
enum TextSize {
  XS,
  SM,
  BASE, // Teks Dasar (text base)
  MD,
  LG,
  XL,
  XL2,  // 2XL
  XL3,  // 3XL
  XL4,  // 4XL
  XL5,  // 5XL
  XL6,  // 6XL
  XL7,  // 7XL
}

extension TextSizeExtension on TextSize {
  double get fontSize {
    switch (this) {
      case TextSize.XS:
        return 12.0;
      case TextSize.SM:
        return 14.0;
      case TextSize.BASE:
        return 16.0; // Teks Dasar (text base)
      case TextSize.MD:
        return 18.0;
      case TextSize.LG:
        return 20.0;
      case TextSize.XL:
        return 24.0; // 2XL
      case TextSize.XL2:
        return 28.0; // 3XL
      case TextSize.XL3:
        return 32.0; // 4XL
      case TextSize.XL4:
        return 36.0; // 5XL
      case TextSize.XL5:
        return 40.0; // 6XL
      case TextSize.XL6:
        return 44.0; // 7XL
      default:
        return 16.0; // Default to Teks Dasar (text base)
    }
  }
}
