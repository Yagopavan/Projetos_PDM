import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('minha tela')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.heart_broken, size: 60),

              Text(
                "D.S. é o melhor curso de SESI?",
                style: TextStyle(fontSize: 22),
              ),

              ElevatedButton(
                onPressed: () {
                  print("Usuário clicou no botão!");
                },
                child: Text("Clique aqui!"),
              ), // ElevatedButton
            ],
          ),
        ),
      ),
    );
  }
}
