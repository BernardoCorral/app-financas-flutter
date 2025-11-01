import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/db_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DbService _db = DbService();

  // estado interno
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

  // Carrega dados iniciais (chamar isso no init do app)
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

  // adicionar transação
  Future<void> addTransaction(TransactionModel tx) async {
    await _db.insertTransaction(tx);
    await loadMonth(_selectedMonth); // recarrega estado
  }

  // editar transação
  Future<void> editTransaction(TransactionModel tx) async {
    if (tx.id == null) return;
    await _db.updateTransaction(tx);
    await loadMonth(_selectedMonth);
  }

  // deletar transação
  Future<void> deleteTransaction(int id) async {
    await _db.deleteTransaction(id);
    await loadMonth(_selectedMonth);
  }

  // trocar de mês (pra futuro: navegação entre meses na UI)
  Future<void> changeMonth(DateTime newMonth) async {
    await loadMonth(newMonth);
  }
}
