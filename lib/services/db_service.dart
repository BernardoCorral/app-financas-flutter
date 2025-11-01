import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    // pega o caminho padrão do SQLite no device
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'financas.db');

    // abre ou cria o banco
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // cria tabela na primeira vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,              -- "despesa" ou "receita"
        value REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL               -- ISO8601
      )
    ''');
  }

  // INSERT
  Future<int> insertTransaction(TransactionModel tx) async {
    final db = await database;
    return await db.insert(
      'transactions',
      tx.toMap()..remove('id'), // remove id null pra deixar o autoincrement funcionar
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // SELECT (todas as transações de um mês específico)
  Future<List<TransactionModel>> getTransactionsByMonth(DateTime month) async {
    final db = await database;

    // começo e fim do mês
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final result = await db.query(
      'transactions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  // UPDATE
  Future<int> updateTransaction(TransactionModel tx) async {
    final db = await database;
    return await db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  // DELETE
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cálculos úteis pro dashboard:

  // total de despesas no mês
Future<double> getMonthlyExpenseTotal(DateTime month) async {
  final List<TransactionModel> list = await getTransactionsByMonth(month);

  double total = 0.0;
  for (var t in list) {
    if (t.type == "despesa") {
      total += t.value;
    }
  }
  return total;
}

// total de receitas no mês
Future<double> getMonthlyIncomeTotal(DateTime month) async {
  final List<TransactionModel> list = await getTransactionsByMonth(month);

  double total = 0.0;
  for (var t in list) {
    if (t.type == "receita") {
      total += t.value;
    }
  }
  return total;
}


  // gasto por categoria no mês (pra montar gráfico de pizza)
  Future<Map<String, double>> getMonthlyExpensesByCategory(DateTime month) async {
    final list = await getTransactionsByMonth(month);
    final Map<String, double> totals = {};

    for (final t in list.where((t) => t.type == "despesa")) {
      totals[t.category] = (totals[t.category] ?? 0) + t.value;
    }

    return totals;
  }
}
