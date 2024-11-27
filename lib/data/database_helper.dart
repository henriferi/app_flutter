import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'tarefas.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            concluida INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTarefas() async {
    final db = await database;
    return db.query('tarefas');
  }

  Future<void> addTarefa(String titulo, bool concluida) async {
    final db = await database;
    await db.insert('tarefas', {
      'titulo': titulo,
      'concluida': concluida ? 1 : 0,
    });
  }

  Future<void> updateTarefa(int id, String titulo, bool concluida) async {
    final db = await database;
    await db.update(
      'tarefas',
      {'titulo': titulo, 'concluida': concluida ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTarefa(int id) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
