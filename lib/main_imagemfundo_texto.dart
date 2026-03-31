import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bmw_m3.jpg"),
            ),
          ),
          child: const Center(
            child: Text(
              "BMW M3",
              style: TextStyle(
                fontSize: 30,
                color:Color.fromARGB(255, 170, 232, 189),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
