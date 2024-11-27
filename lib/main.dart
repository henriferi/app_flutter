import 'package:flutter/material.dart';
import 'screens/cadastro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tarefas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Cadastro',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/tarefas': (context) => const TarefasScreen(),
      },
    );
  }
}
