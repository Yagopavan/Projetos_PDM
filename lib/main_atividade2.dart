import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ContadorTela());
  }
}

class ContadorTela extends StatefulWidget {
  const ContadorTela({super.key});

  @override
  _ContadorTelaState createState() => _ContadorTelaState();
}

class _ContadorTelaState extends State<ContadorTela> {
  int contador = 0;

  void incrementar() {
    setState(() {
      contador++;
    });
  }

  void desincrementar() {
    setState(() {
      if (contador > 0) {
        contador--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('minha tela')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 60, color: Colors.red),
            Text("Curtidas: $contador", style: TextStyle(fontSize: 22)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: incrementar,
                  child: Text("👍 Gostei"),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: desincrementar,
                  child: Text("👎Não Gostei"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
