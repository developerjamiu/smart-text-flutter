import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_text_flutter/src/extensions/item_span_default_config.dart';
import 'package:smart_text_flutter/smart_text_flutter.dart';
import 'package:smart_text_flutter/src/extensions/string.dart';

/// The smart text which automatically detect links in text and renders them
class SmartSelectableText extends StatefulWidget {
  const SmartSelectableText(
    this.text, {
    super.key,
    this.config,
    this.addressConfig,
    this.dateTimeConfig,
    this.emailConfig,
    this.phoneConfig,
    this.urlConfig,
    this.strutStyle,
    this.locale,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.selectionColor,
    this.semanticsLabel,
    this.softWrap,
    this.textHeightBehavior,
    this.textScaler,
    this.textWidthBasis,
    this.humanize = false,
  });

  /// The text to linkify
  /// This text will be classified and the links will be highlighted
  final String text;

  /// The configuration for setting the [TextStyle] and onClicked method
  /// This affects the whole text
  final ItemSpanConfig? config;

  /// The configuration for setting the [TextStyle] and what happens when the address link is clicked
  final ItemSpanConfig? addressConfig;

  /// The configuration for setting the [TextStyle] and what happens when the phone link is clicked
  final ItemSpanConfig? phoneConfig;

  /// The configuration for setting the [TextStyle] and what happens when the url is clicked
  final ItemSpanConfig? urlConfig;

  /// The configuration for setting the [TextStyle] and what happens when the date time is clicked
  final ItemSpanConfig? dateTimeConfig;

  /// The configuration for setting the [TextStyle] and what happens when the email link is clicked
  final ItemSpanConfig? emailConfig;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final TextScaler? textScaler;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final ui.TextHeightBehavior? textHeightBehavior;

  final Color? selectionColor;

  final bool humanize;

  @override
  State<SmartSelectableText> createState() => _SmartSelectableTextState();
}

class _SmartSelectableTextState extends State<SmartSelectableText> {
  late Future<List<ItemSpan>> classifyTextFuture;

  @override
  void initState() {
    super.initState();

    classifyTextFuture = getItemSpans();
  }

  @override
  void didUpdateWidget(covariant SmartSelectableText oldWidget) {
    if (oldWidget.text != widget.text) classifyTextFuture = getItemSpans();

    super.didUpdateWidget(oldWidget);
  }

  Future<List<ItemSpan>> getItemSpans() async {
    return SmartTextFlutter.classifyText(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemSpan>>(
      future: classifyTextFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SelectableText(
            widget.text,
            style: widget.config?.textStyle,
            strutStyle: widget.strutStyle,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            semanticsLabel: widget.semanticsLabel,
            textDirection: widget.textDirection,
            textHeightBehavior: widget.textHeightBehavior,
            textScaler: widget.textScaler,
            textWidthBasis: widget.textWidthBasis,
          );
        }

        return SelectableText.rich(
          TextSpan(
            children: [
              for (final span in snapshot.data!)
                switch (span.type) {
                  ItemSpanType.text => TextSpan(
                      text: span.text,
                      style: span.defaultConfig.textStyle?.merge(
                        widget.config?.textStyle,
                      ),
                    ),
                  ItemSpanType.address => TextSpan(
                      text: span.text,
                      style: span.defaultConfig.textStyle?.merge(
                        widget.addressConfig?.textStyle,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleItemSpanTap(
                              span,
                              widget.addressConfig,
                            ),
                    ),
                  ItemSpanType.email => TextSpan(
                      text: span.text,
                      style: span.defaultConfig.textStyle?.merge(
                        widget.emailConfig?.textStyle,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleItemSpanTap(
                              span,
                              widget.emailConfig,
                            ),
                    ),
                  ItemSpanType.phone => TextSpan(
                      text: span.text,
                      style: span.defaultConfig.textStyle?.merge(
                        widget.phoneConfig?.textStyle,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleItemSpanTap(
                              span,
                              widget.phoneConfig,
                            ),
                    ),
                  ItemSpanType.datetime => TextSpan(
                      text: span.text,
                      style: span.defaultConfig.textStyle?.merge(
                        widget.dateTimeConfig?.textStyle,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleItemSpanTap(
                              span,
                              widget.dateTimeConfig,
                            ),
                    ),
                  ItemSpanType.url => TextSpan(
                      text: span.text.humanizeUrl(widget.humanize),
                      style: span.defaultConfig.textStyle?.merge(
                        widget.urlConfig?.textStyle,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _handleItemSpanTap(
                              span,
                              widget.urlConfig,
                            ),
                    ),
                },
            ],
            style: const TextStyle().merge(
              widget.config?.textStyle,
            ),
          ),
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          semanticsLabel: widget.semanticsLabel,
          textDirection: widget.textDirection,
          textHeightBehavior: widget.textHeightBehavior,
          textScaler: widget.textScaler,
          textWidthBasis: widget.textWidthBasis,
        );
      },
    );
  }

  void _handleItemSpanTap(ItemSpan span, ItemSpanConfig? config) {
    if (config?.onClicked != null) {
      config?.onClicked?.call(span.rawValue);
    } else {
      span.defaultConfig.onClicked?.call(span.rawValue);
    }
  }
}
