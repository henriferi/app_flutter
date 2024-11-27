import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'login_screen.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  _TarefasScreenState createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final tarefas = await _dbHelper.getTarefas();
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> _adicionarTarefa(String titulo) async {
    await _dbHelper.addTarefa(titulo, false);
    _carregarTarefas();
  }

  Future<void> _alterarTarefa(int id, String titulo, bool concluida) async {
    await _dbHelper.updateTarefa(id, titulo, concluida);
    _carregarTarefas();
  }

  Future<void> _removerTarefa(int id) async {
    await _dbHelper.deleteTarefa(id);
    _carregarTarefas();
  }

  void _marcarConcluida(int id, String titulo, bool atual) async {
    await _dbHelper.updateTarefa(id, titulo, !atual);
    _carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    final tarefasNaoConcluidas =
    _tarefas.where((t) => t['concluida'] == 0).toList();
    final tarefasConcluidas =
    _tarefas.where((t) => t['concluida'] == 1).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tarefas Pendentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tarefasNaoConcluidas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefasNaoConcluidas[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        tarefa['titulo'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _mostrarDialogoEditarTarefa(
                                tarefa['id'], tarefa['titulo'], false),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _marcarConcluida(
                                tarefa['id'], tarefa['titulo'], false),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerTarefa(tarefa['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const Text(
              'Tarefas Concluídas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tarefasConcluidas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefasConcluidas[index];
                  return Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        tarefa['titulo'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerTarefa(tarefa['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => _mostrarDialogoAdicionarTarefa(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    'Adicionar Tarefa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAdicionarTarefa() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Tarefa'),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final titulo = _controller.text;
              if (titulo.isNotEmpty) _adicionarTarefa(titulo);
              Navigator.of(context).pop();
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEditarTarefa(int id, String tituloAtual, bool concluida) {
    final TextEditingController _controller = TextEditingController();
    _controller.text = tituloAtual;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final novoTitulo = _controller.text;
              if (novoTitulo.isNotEmpty) {
                _alterarTarefa(id, novoTitulo, concluida);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
