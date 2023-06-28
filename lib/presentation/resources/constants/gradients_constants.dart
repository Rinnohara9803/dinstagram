import 'package:flutter/material.dart';

import '../colors_manager.dart';

class GradientsConstants {
  static LinearGradient linearGradient0 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [
      0.2,
      0.5,
      0.2,
    ],
    colors: [
      ColorsManager.lightRed,
      ColorsManager.lightBlue,
      ColorsManager.lightGreen,
    ],
  );
}
