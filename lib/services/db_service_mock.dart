import '../models/transaction_model.dart';

// Banco falso em memória, só pra rodar no Flutter Web
class DbServiceMock {
  // lista fixa simulando o banco
  final List<TransactionModel> _items = [];

  // INSERT
  Future<int> insertTransaction(TransactionModel tx) async {
    // simula autoincrement
    final newId = _items.length + 1;
    final withId = tx.copyWith(id: newId);
    _items.add(withId);
    return newId;
  }

  // SELECT por mês
  Future<List<TransactionModel>> getTransactionsByMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    return _items.where((t) {
      return t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
             t.date.isBefore(end.add(const Duration(seconds: 1)));
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // UPDATE
  Future<int> updateTransaction(TransactionModel tx) async {
    final index = _items.indexWhere((e) => e.id == tx.id);
    if (index != -1) {
      _items[index] = tx;
      return 1;
    }
    return 0;
  }

  // DELETE
  Future<int> deleteTransaction(int id) async {
    final before = _items.length;
    _items.removeWhere((e) => e.id == id);
    return before - _items.length;
  }

  // totais e agregações (mesmos helpers que tínhamos no sqlite)
  Future<double> getMonthlyExpenseTotal(DateTime month) async {
    final list = await getTransactionsByMonth(month);
    double total = 0.0;
    for (var t in list) {
      if (t.type == "despesa") total += t.value;
    }
    return total;
  }

  Future<double> getMonthlyIncomeTotal(DateTime month) async {
    final list = await getTransactionsByMonth(month);
    double total = 0.0;
    for (var t in list) {
      if (t.type == "receita") total += t.value;
    }
    return total;
  }

  Future<Map<String, double>> getMonthlyExpensesByCategory(DateTime month) async {
    final list = await getTransactionsByMonth(month);
    final Map<String, double> totals = {};
    for (final t in list.where((t) => t.type == "despesa")) {
      totals[t.category] = (totals[t.category] ?? 0) + t.value;
    }
    return totals;
  }
}
