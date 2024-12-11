import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('API Test')),
        body: const APIExample(),
      ),
    );
  }
}

class APIExample extends StatefulWidget {
  const APIExample({super.key});

  @override
  _APIExampleState createState() => _APIExampleState();
}

class _APIExampleState extends State<APIExample> {
  String _response = 'Premi il bottone per fare una richiesta';

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:1865/api/example-endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _response = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          _response = 'Errore nella richiesta: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Eccezione catturata: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_response, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: fetchData,
          child: const Text('Fai una richiesta'),
        ),
      ],
    );
  }
}
