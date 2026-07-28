import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF607D8B)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
      ),
      home: const TarefasPage(),
    );
  }
}

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  List<Map<String, dynamic>> _tarefas = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarTarefas(); 
  }

 
  Future<void> _carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('tarefas');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        _tarefas = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } else {
      _tarefas = [
        {'titulo': 'Entregar tarefa PDM', 'concluida': true},

      ];
      _salvarTarefas(); 
    }
  }

  Future<void> _salvarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(_tarefas);
    await prefs.setString('tarefas', jsonString);
  }


  void _adicionarTarefa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Tarefa'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite o título da tarefa',
          ),
          onSubmitted: (_) => _salvarTarefaComSnack(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _salvarTarefaComSnack(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

 
  void _salvarTarefaComSnack(BuildContext context) {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        _tarefas.add({'titulo': texto, 'concluida': false});
      });
      _salvarTarefas(); 
      _controller.clear();
      Navigator.pop(context);

    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Tarefa "$texto" adicionada!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }

  void _excluirTarefa(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tarefas.removeAt(index);
              });
              _salvarTarefas();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tarefa excluída!'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red[700],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _alternarConclusao(int index) {
    setState(() {
      _tarefas[index]['concluida'] = !_tarefas[index]['concluida'];
    });
    _salvarTarefas();
  }

  void _editarTarefa(int index) {
    _controller.text = _tarefas[index]['titulo'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite a nova tarefa',
          ),
          onSubmitted: (_) => _salvarEdicao(context, index),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _salvarEdicao(context, index),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _salvarEdicao(BuildContext context, int index) {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        _tarefas[index]['titulo'] = texto;
      });
      _salvarTarefas();
      _controller.clear();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Tarefa "$texto" atualizada!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue[700],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Minhas Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: _tarefas.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Nenhuma tarefa ainda.\nToque em + para adicionar!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: _tarefas.length,
                  itemBuilder: (context, index) {
                    final tarefa = _tarefas[index];
                    return Card(
                      color: const Color(0xFFF8F8F8),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        leading: Checkbox(
                          value: tarefa['concluida'],
                          activeColor: const Color(0xFF607D8B),
                          onChanged: (_) => _alternarConclusao(index),
                        ),
                        title: Center(
                          child: Text(
                            tarefa['titulo'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: tarefa['concluida']
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: tarefa['concluida']
                                  ? Colors.grey
                                  : const Color(0xFF263238),
                            ),
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF2196F3)),
                                onPressed: () => _editarTarefa(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Color(0xFF78909C)),
                                onPressed: () => _excluirTarefa(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTarefa,
        backgroundColor: const Color.fromARGB(255, 49, 51, 49),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
