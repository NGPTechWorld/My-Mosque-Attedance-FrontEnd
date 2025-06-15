import 'package:flutter/material.dart';
import '../../app/config/color_manager.dart';
import '../../app/config/style_manager.dart';

class SnackBarCustom {
  static void show(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Center(
          child: Text(
            msg,
            style: StyleManager.h4_Semibold(color: ColorManager.whiteColor),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
