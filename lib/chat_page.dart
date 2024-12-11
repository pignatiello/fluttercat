import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String accessToken;

  const ChatPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> _messages = []; // Lista dei messaggi
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      setState(() {
        _messages.add("Tu: $message");
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:1865/message'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.accessToken}',
          },
          body: jsonEncode({'text': message}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final reply = data['content'];

          setState(() {
            _messages.add("FlutterCat: $reply");
          });
        } else {
          setState(() {
            _messages.add("Errore dal server: ${response.statusCode}");
          });
        }
      } catch (e) {
        setState(() {
          _messages.add("Errore di connessione: $e");
        });
      }

      // Pulisce il campo di input
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterCat'),
      ),
      body: Column(
        children: [
          // Lista dei messaggi
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Align(
                    alignment: message.startsWith("Tu:")
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: message.startsWith("Tu:")
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Barra di input con SafeArea
          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, -1),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Scrivi un messaggio...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
