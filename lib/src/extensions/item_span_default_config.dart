import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_text_flutter/src/models/item_span_config.dart';
import 'package:smart_text_flutter/src/models/item_span.dart';
import 'package:url_launcher/url_launcher.dart';

extension ItemSpanDefaultConfig on ItemSpan {
  static const defaultStyle = TextStyle();

  static const underlineStyle = TextStyle(
    decoration: TextDecoration.underline,
  );

  static const coloredUnderlineStyle = TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    decorationColor: Colors.blue,
  );

  ItemSpanConfig get defaultConfig {
    switch (type) {
      case ItemSpanType.text:
        return const ItemSpanConfig(
          textStyle: defaultStyle,
        );
      case ItemSpanType.address:
        return ItemSpanConfig(
          textStyle: underlineStyle,
          onClicked: _onAddressClicked,
        );

      case ItemSpanType.email:
        return ItemSpanConfig(
          textStyle: coloredUnderlineStyle,
          onClicked: _onEmailClicked,
        );
      case ItemSpanType.phone:
        return ItemSpanConfig(
          textStyle: coloredUnderlineStyle,
          onClicked: _onPhoneClicked,
        );
      case ItemSpanType.datetime:

        /// The formatted phone number is currently not returned in Android
        /// In this case, we do not want to represent the phone field as a
        /// clickable link
        final hasFormattedDate = text != rawValue;

        return ItemSpanConfig(
          textStyle: hasFormattedDate ? underlineStyle : null,
          onClicked: hasFormattedDate ? _onDateTimeClicked : null,
        );
      case ItemSpanType.url:
        return ItemSpanConfig(
          textStyle: coloredUnderlineStyle,
          onClicked: _onUrlClicked,
        );
    }
  }

  void _onAddressClicked(String address) async {
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri(
        scheme: 'geo',
        host: '0,0',
        queryParameters: {'q': address},
      );
    } else if (Platform.isIOS) {
      uri = Uri.http(
        'maps.apple.com',
        '/',
        {'q': address},
      );
    } else {
      uri = Uri.https(
        'www.google.com',
        '/maps/search/',
        {'api': '1', 'query': address},
      );
    }

    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _onDateTimeClicked(String dateTime) {}

  void _onEmailClicked(String email) => _launchUrl(email);

  void _onPhoneClicked(String phone) => _launchUrl(phone);

  void _onUrlClicked(String url) => _launchUrl(url);

  void _launchUrl(String url) async {
    launchUrl(Uri.parse(url)).ignore();
  }
}
