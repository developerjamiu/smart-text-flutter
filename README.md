# Smart Text Flutter

A Flutter plugin used to find links in plain texts.

|             | Android | iOS   |
|-------------|---------|-------|
| **Support** | SDK 19+ | 11.0+ |

It uses [NSDataDetector](https://developer.apple.com/documentation/foundation/nsdatadetector) for iOS and [TextClassifier](https://developer.android.com/reference/android/view/textclassifier/TextClassifier) for Android.

It exposes a static method `classifyText` which returns a list of ItemSpan with the classified texts arranged in sequence. The ItemSpan contains the text and the type of text (where the type can either be an address, email, datetime, url, phone and a text).

Here's example which shows how to implement widget that uses the `classifyText` method and turns the ItemSpans into clickable links:

## Usage

To use this plugin, add `smart_text_flutter` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

<?code-excerpt "lib/smart_text.dart (basic-example)"?>
```dart
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
```

### Android

Address and DateTime are not supported on Android 8.1 (API 27) and below