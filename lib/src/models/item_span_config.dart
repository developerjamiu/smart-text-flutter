import 'package:flutter/material.dart';

class ItemSpanConfig {
  final TextStyle? textStyle;
  final void Function(String data)? onClicked;

  const ItemSpanConfig({
    this.textStyle,
    this.onClicked,
  });
}
