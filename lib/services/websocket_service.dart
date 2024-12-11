import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  Stream<Map<String, dynamic>> get messages =>
      _channel.stream.map((event) => jsonDecode(event));

  void close() {
    _channel.sink.close();
  }
}
