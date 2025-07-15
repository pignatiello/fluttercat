import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();

  // Stream per i messaggi ricevuti
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  // Connetti al WebSocket
  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Ascolta i messaggi dal server
      _channel.stream.listen(
        (event) {
          final decodedMessage = jsonDecode(event);
          _messageController.add(decodedMessage);
        },
        onError: (error) {
          // ignore: avoid_print
          print('Errore WebSocket: $error');
        },
        onDone: () {
          // ignore: avoid_print
          print('WebSocket chiuso');
        },
      );

      // ignore: avoid_print
      print('Connesso a WebSocket: $url');
    } catch (e) {
      // ignore: avoid_print
      print('Errore durante la connessione al WebSocket: $e');
    }
  }

  // Invia un messaggio al server
  void sendMessage(Map<String, dynamic> message) {
    try {
      _channel.sink.add(jsonEncode(message));
      // ignore: avoid_print
      print('Messaggio inviato: $message');
    } catch (e) {
      // ignore: avoid_print
      print('Errore durante l\'invio del messaggio: $e');
    }
  }

  // Chiudi la connessione
  void close() {
    _channel.sink.close();
    _messageController.close();
    // ignore: avoid_print
    print('Connessione WebSocket chiusa');
  }
}
