import 'package:flutter/material.dart';
import 'package:smart_text_flutter_example/smart_text.dart';

void main() {
  runApp(const SmartTextFlutterExample());
}

class SmartTextFlutterExample extends StatelessWidget {
  const SmartTextFlutterExample({super.key});

  @override
  Widget build(BuildContext context) {
    const text =
        'Here is a text with an address: 36 Lagos Street written at 9PM by someone with phone: +2340000000000 and you can reach him at reaching@email.com or you can check twitter.com';

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
