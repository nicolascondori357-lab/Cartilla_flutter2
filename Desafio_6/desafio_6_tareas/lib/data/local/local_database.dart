import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/tarea.dart';

class LocalDatabase {

  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tareas.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearDB,
    );
  }

  Future<void> _crearDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tareas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        completada INTEGER NOT NULL,
        prioridad TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertar(Tarea tarea) async {
    final db = await database;

    return await db.insert(
      'tareas',
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarea>> obtenerTodas() async {
    final db = await database;

    final maps = await db.query(
      'tareas',
      orderBy: 'id DESC',
    );

    return maps.map((map) => Tarea.fromMap(map)).toList();
  }

  Future<int> actualizar(Tarea tarea) async {
    final db = await database;

    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await database;

    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}