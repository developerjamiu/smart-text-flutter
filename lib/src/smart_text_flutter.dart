import 'dart:async';

import 'package:smart_text_flutter/smart_text_flutter_platform_interface.dart';
import 'package:smart_text_flutter/src/models/item_span.dart';

class SmartTextFlutter {
  SmartTextFlutter._();

  static final _smartTextFlutter = SmartTextFlutterPlatform.instance;

  /// Parses [text] into [ItemSpan] sequence
  ///
  /// Returns list of [ItemSpan]s with the classified texts arranged in sequence.
  /// [ItemSpan] contains the text and the type of text
  ///
  /// ```dart
  /// final entries = SmartTextFlutter.classifyText('text with 36 Lagos Street and link http://nigeria.com')
  /// // returns
  /// // [
  /// //   ItemSpan(text: 'text with ', type: ItemSpanType.text),
  /// //   ItemSpan(text: '36 Lagos Street', type: ItemSpanType.address),
  /// //   ItemSpan(text: ' and link ', type: ItemSpanType.text),
  /// //   ItemSpan(text: 'http://nigeria.com', type: ItemSpanType.url),
  /// // ]
  /// ```
  ///
  /// The method is useful when you want to show links in UI with the rest of
  /// the text:
  ///
  /// ```dart
  /// class SmartText extends StatefulWidget {
  ///   const SmartText(this.text, {super.key});

  ///   final String text;

  ///   @override
  ///   State<SmartText> createState() => _SmartTextState();
  /// }

  /// class _SmartTextState extends State<SmartText> {
  ///   late Future<List<ItemSpan>> classifyTextFuture;

  ///   @override
  ///   void initState() {
  ///     super.initState();

  ///     classifyTextFuture = getItemSpans();
  ///   }

  ///   @override
  ///   void didUpdateWidget(covariant SmartText oldWidget) {
  ///     if (oldWidget.text != widget.text) classifyTextFuture = getItemSpans();

  ///     super.didUpdateWidget(oldWidget);
  ///   }

  ///   Future<List<ItemSpan>> getItemSpans() async {
  ///     return SmartTextFlutter.classifyText(widget.text);
  ///   }

  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FutureBuilder<List<ItemSpan>>(
  ///       future: classifyTextFuture,
  ///       builder: (context, snapshot) {
  ///         if (!snapshot.hasData || snapshot.data!.isEmpty) {
  ///           return Text(widget.text);
  ///         }

  ///         return Text.rich(
  ///           TextSpan(
  ///             children: [
  ///               for (final span in snapshot.data!)
  ///                 switch (span.type) {
  ///                   ItemSpanType.text => TextSpan(
  ///                       text: span.text,
  ///                     ),
  ///                   ItemSpanType.address => TextSpan(
  ///                       text: span.text,
  ///                       // replace with link style
  ///                       style: const TextStyle(color: Colors.red),
  ///                       recognizer: TapGestureRecognizer()
  ///                         ..onTap = () {
  ///                           // perform address related action
  ///                         },
  ///                     ),
  ///                   ItemSpanType.email => TextSpan(
  ///                       text: span.text,
  ///                       // replace with link style
  ///                       style: const TextStyle(color: Colors.blue),
  ///                       recognizer: TapGestureRecognizer()
  ///                         ..onTap = () {
  ///                           // perform email related action
  ///                         },
  ///                     ),
  ///                   ItemSpanType.phone => TextSpan(
  ///                       text: span.text,
  ///                       // replace with link style
  ///                       style: const TextStyle(color: Colors.green),
  ///                       recognizer: TapGestureRecognizer()
  ///                         ..onTap = () {
  ///                           // perform phone related action
  ///                         },
  ///                     ),
  ///                   ItemSpanType.datetime => TextSpan(
  ///                       text: span.text,
  ///                       // replace with link style
  ///                       style: const TextStyle(color: Colors.indigo),
  ///                       recognizer: TapGestureRecognizer()
  ///                         ..onTap = () {
  ///                           // perform datetime related action
  ///                         },
  ///                     ),
  ///                   ItemSpanType.url => TextSpan(
  ///                       text: span.text,
  ///                       // replace with link style
  ///                       style: const TextStyle(color: Colors.amber),
  ///                       recognizer: TapGestureRecognizer()
  ///                         ..onTap = () {
  ///                           // perform url related action
  ///                         },
  ///                     ),
  ///                 }
  ///             ],
  ///           ),
  ///         );
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  static Future<List<ItemSpan>> classifyText(String text) async {
    try {
      final result = await _smartTextFlutter.classifyText(
        text,
      );

      if (result == null) return const [];

      return result
          .map((e) => ItemSpan.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (ex) {
      return const [];
    }
  }
}
