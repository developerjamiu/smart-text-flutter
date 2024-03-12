import 'package:flutter/material.dart';
import 'package:smart_text_flutter/smart_text_flutter.dart';

void main() {
  runApp(const SmartTextFlutterExample());
}

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
