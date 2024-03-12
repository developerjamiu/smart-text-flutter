import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_text_flutter/src/extensions/item_span_default_config.dart';
import 'package:smart_text_flutter/smart_text_flutter.dart';

class SmartText extends StatefulWidget {
  const SmartText(
    this.text, {
    super.key,
    this.config,
    this.addressConfig,
    this.dateTimeConfig,
    this.emailConfig,
    this.phoneConfig,
    this.urlConfig,
  });

  final String text;
  final ItemSpanConfig? config;
  final ItemSpanConfig? addressConfig;
  final ItemSpanConfig? phoneConfig;
  final ItemSpanConfig? urlConfig;
  final ItemSpanConfig? dateTimeConfig;
  final ItemSpanConfig? emailConfig;

  @override
  State<SmartText> createState() => _SmartTextState();
}

class _SmartTextState extends State<SmartText> {
  late Future<List<ItemSpan>> classifyTextFuture;

  @override
  void initState() {
    super.initState();

    classifyTextFuture = getItemSpans();
  }

  @override
  void didUpdateWidget(covariant SmartText oldWidget) {
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
          return Text(
            widget.text,
            style: widget.config?.textStyle,
          );
        }

        return Text.rich(
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
                      text: span.text,
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
