# Smart Text Flutter

A Flutter plugin used to find links in plain texts.

|             | Android | iOS   |
| ----------- | ------- | ----- |
| **Support** | SDK 19+ | 11.0+ |

It uses [NSDataDetector](https://developer.apple.com/documentation/foundation/nsdatadetector) for iOS and [TextClassifier](https://developer.android.com/reference/android/view/textclassifier/TextClassifier) for Android.

**Texts (links) can be among these 6 types**

```Dart
enum ItemSpanType { address, phone, email, datetime, url, text }
```

## Usage

To use this plugin, add `smart_text_flutter` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

**Example**

```Dart
class SmartTextFlutterExample extends StatelessWidget {
  const SmartTextFlutterExample({super.key});

  @override
  Widget build(BuildContext context) {
    const text =
        'Here is a text with an address: 36 Lagos Street written at 9 PM by someone with phone: +2340000000000 and you can reach him at reaching@email.com or you can check twitter.com';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Text Flutter'),
        ),
        body: const Center(
          child: SmartText(text),
        ),
      ),
    );
  }
}
```

**Demo**

![ScreenRecording2024-03-12at17 38 55-ezgif com-resize](https://github.com/developerjamiu/smart-text-flutter/assets/50176100/dfb4f68e-77d3-4acc-9e07-a27239aa519b)

## Notes

- DateTime is not supported on Android
- Address is not supported on Android 8.1 (API 27) and below
- There is no default implementation for when DateTime is clicked (the formatted date returned in the callback in case)

## Properties

```Dart
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

  /// By default, URLs in the text (e.g., starting with http:// or https://) are displayed as-is.
  /// Set humanize to true to remove the protocol (e.g., http:// or https://).
  final bool humanize;

  /// Other properties have the same usage as the Flutter text widget
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
```

**ItemSpanConfig**

```Dart
  /// The [TextStyle] if the link
  final TextStyle? textStyle;

  /// The method called when a link is clicked
  /// When the is set, the implementation will override the default
  /// implementation
  final void Function(String data)? onClicked;
```

**The smart text widget example**

```Dart
  SmartText(
    text,
    config: const ItemSpanConfig(
      textStyle: TextStyle(),
    ),
    addressConfig: ItemSpanConfig(
      textStyle: const TextStyle(),
      onClicked: (_) {},
    ),
    emailConfig: ItemSpanConfig(
      textStyle: const TextStyle(),
      onClicked: (_) {},
    ),
    phoneConfig: ItemSpanConfig(
      textStyle: const TextStyle(),
      onClicked: (_) {},
    ),
    urlConfig: ItemSpanConfig(
      textStyle: const TextStyle(),
      onClicked: (_) {},
    ),
    dateTimeConfig: ItemSpanConfig(
      textStyle: const TextStyle(),
      onClicked: (_) {},
    ),
  )
```

**Code from the example folder.**

```Dart
class SmartTextFlutterExample extends StatefulWidget {
  const SmartTextFlutterExample({super.key});

  @override
  State<SmartTextFlutterExample> createState() =>
      _SmartTextFlutterExampleState();
}

class _SmartTextFlutterExampleState extends State<SmartTextFlutterExample> {
  final List<String> messageTexts = [];

  late final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Text Flutter'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messageTexts.length,
                itemBuilder: (context, index) => Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey.shade50,
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    child: SmartText(
                      messageTexts[index],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter text',
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => messageTexts.add(_messageController.text));
                      _messageController.clear();
                    },
                    child: const Text('Send Message'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
```

## Bugs/Requests

If you encounter any problems feel free to open an issue [here](https://github.com/developerjamiu/smart-text-flutter/issues). If you feel the library is missing a feature, please raise a ticket on GitHub and I'll look into it. Pull requests are also welcome.
