import 'package:flutter/material.dart';
import 'services/WebSocketService.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketService _webSocketService;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _webSocketService.connect('ws://localhost:1865/ws');

    // Ascolta i messaggi dal server
    _webSocketService.messages.listen((message) {
      setState(() {
        // intero messaggio
        // _messages.add('Server: ${message.toString()}');
        // Estrai solo i campi content e tool-name
        final content = message['content'] ?? 'Nessun contenuto';

        // Formatta il messaggio
        _messages.add('Contenuto: $content');

        // Accedi alla sezione 'why'
        final why = message['why'];

        // Estrai il valore da 'input'
        //final input = why?['input'] ?? 'Nessun input';

        // Estrai il primo valore da 'intermediate_steps'
        final intermediateSteps = why?['intermediate_steps'];
        final firstStep =
            (intermediateSteps is List && intermediateSteps.isNotEmpty)
                ? intermediateSteps.first[0]
                : 'Nessun passaggio intermedio';

        // Aggiungi i risultati alla chat
        //_messages.add('Input: $input');
        _messages.add('Primo Passaggio: $firstStep');
      });
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _webSocketService.sendMessage({'text': message});
      setState(() {
        _messages.add('Tu: $message');
        _messageController.clear();
      });
    }
  }

  @override
  void dispose() {
    _webSocketService.close();
    super.dispose();
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
