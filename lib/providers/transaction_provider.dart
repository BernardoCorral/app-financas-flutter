import 'package:flutter/foundation.dart' show ChangeNotifier, kIsWeb;
import '../models/transaction_model.dart';
import '../services/db_service.dart';
import '../services/db_service_mock.dart';

class TransactionProvider extends ChangeNotifier {
  late final dynamic _db;

  TransactionProvider() {
    if (kIsWeb) {
      _db = DbServiceMock();
    } else {
      _db = DbService();
    }
  }

  List<TransactionModel> _currentMonthTransactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  Map<String, double> _expenseByCategory = {};

  DateTime _selectedMonth = DateTime.now();

  List<TransactionModel> get transactions => _currentMonthTransactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  Map<String, double> get expenseByCategory => _expenseByCategory;
  DateTime get selectedMonth => _selectedMonth;

  // carregar dados do mês
  Future<void> loadMonth([DateTime? month]) async {
    if (month != null) {
      _selectedMonth = month;
    }

    _currentMonthTransactions =
        await _db.getTransactionsByMonth(_selectedMonth);

    _totalIncome = await _db.getMonthlyIncomeTotal(_selectedMonth);
    _totalExpense = await _db.getMonthlyExpenseTotal(_selectedMonth);
    _expenseByCategory =
        await _db.getMonthlyExpensesByCategory(_selectedMonth);

    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _db.insertTransaction(tx);
    await loadMonth(_selectedMonth);
  }

  Future<void> editTransaction(TransactionModel tx) async {
    if (tx.id == null) return;
    await _db.updateTransaction(tx);
    await loadMonth(_selectedMonth);
  }

  Future<void> deleteTransaction(int id) async {
    await _db.deleteTransaction(id);
    await loadMonth(_selectedMonth);
  }

  Future<void> changeMonth(DateTime newMonth) async {
    await loadMonth(newMonth);
  }
}
