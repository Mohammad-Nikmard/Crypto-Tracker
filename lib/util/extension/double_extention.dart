import 'package:crypto_baazar/constants/constants.dart';
import 'package:flutter/material.dart';

extension CryptoExtension on double {
  Color convertToColor() {
    if (this < 0) {
      return MyColors.redColor;
    } else {
      return MyColors.greenColor;
    }
  }

  Icon convertToIcon() {
    if (this < 0) {
      return const Icon(
        Icons.trending_down,
        color: MyColors.redColor,
      );
    } else {
      return const Icon(
        Icons.trending_up,
        color: MyColors.greenColor,
      );
    }
  }
}
