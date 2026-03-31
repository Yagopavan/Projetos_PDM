import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Texto Imagem"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bem Vindo",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/bmw_m3.jpg',
                width: 200,
              )
            ],
          ),
          ),
        ),
      );
  }
}