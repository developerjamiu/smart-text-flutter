import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_text_flutter/smart_text_flutter.dart';

class SmartText extends StatefulWidget {
  const SmartText(this.text, {super.key});

  final String text;

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
          return Text(widget.text);
        }

        return Text.rich(
          TextSpan(
            children: [
              for (final span in snapshot.data!)
                switch (span.type) {
                  ItemSpanType.text => TextSpan(
                      text: span.text,
                    ),
                  ItemSpanType.address => TextSpan(
                      text: span.text,
                      // replace with link style
                      style: const TextStyle(color: Colors.red),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // perform address related action
                        },
                    ),
                  ItemSpanType.email => TextSpan(
                      text: span.text,
                      // replace with link style
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // perform email related action
                        },
                    ),
                  ItemSpanType.phone => TextSpan(
                      text: span.text,
                      // replace with link style
                      style: const TextStyle(color: Colors.green),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // perform phone related action
                        },
                    ),
                  ItemSpanType.datetime => TextSpan(
                      text: span.text,
                      // replace with link style
                      style: const TextStyle(color: Colors.indigo),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // perform datetime related action
                        },
                    ),
                  ItemSpanType.url => TextSpan(
                      text: span.text,
                      // replace with link style
                      style: const TextStyle(color: Colors.amber),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // perform url related action
                        },
                    ),
                }
            ],
          ),
        );
      },
    );
  }
}
