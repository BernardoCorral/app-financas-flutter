import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.tx,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = tx.type == "despesa";

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isExpense ? Colors.red[100] : Colors.green[100],
        child: Icon(
          isExpense ? Icons.arrow_downward : Icons.arrow_upward,
          color: isExpense ? Colors.red : Colors.green,
          size: 20,
        ),
      ),
      title: Text(
        tx.description,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "${tx.category} • ${formatDate(tx.date)}",
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: Text(
        (isExpense ? "- " : "+ ") + formatCurrency(tx.value),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isExpense ? Colors.red : Colors.green,
          fontSize: 16,
        ),
      ),
      onTap: onEdit,
      onLongPress: onDelete,
    );
  }
}
