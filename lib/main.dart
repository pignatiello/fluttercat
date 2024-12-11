import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Sfondo bianco
        appBarTheme: const AppBarTheme(
          color: Colors.blue, //colore barra in alto
          foregroundColor: Colors.white, // Colore del testo e icone nella barra
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _response = '';

  // **Metodo aggiunto per abilitare i plugin**
  Future<void> enablePlugins(String accessToken) async {
    final url = Uri.parse('http://localhost:1865/plugins/enable');
    final pluginsToEnable = {
      "plugins": [
        "C.A.T. - Cat Advanced Tools"
      ] // Aggiungi il nome dei tuoi plugin
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(pluginsToEnable),
      );

      if (response.statusCode == 200) {
        print('Plugins abilitati con successo');
      } else {
        print('Errore nell\'abilitazione dei plugin: ${response.body}');
      }
    } catch (e) {
      print('Eccezione catturata durante l\'abilitazione dei plugin: $e');
    }
  }

  Future<void> login() async {
    final url =
        Uri.parse('http://localhost:1865/auth/token'); // Endpoint per il login
    final body = {
      "username": _usernameController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data["access_token"];

        // **Chiamata aggiunta per abilitare i plugin**
        await enablePlugins(accessToken);

        // Naviga alla pagina della chat con il token
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(accessToken: accessToken),
          ),
        );
      } else if (response.statusCode == 422) {
        setState(() {
          _response = 'Validation Error: ${response.body}';
        });
      } else {
        setState(() {
          _response = 'Errore: ${response.statusCode} - ${response.body}';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: login,
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          Text(_response),
        ],
      ),
    );
  }
}
