import 'package:flutter/material.dart';

class ItemSpanConfig {
  /// The [TextStyle] if the link
  final TextStyle? textStyle;

  /// The method called when a link is clicked
  /// When the is set, the implementation will override the default
  /// implementation
  final void Function(String data)? onClicked;

  const ItemSpanConfig({
    this.textStyle,
    this.onClicked,
  });
}
