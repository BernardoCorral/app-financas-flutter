import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/settings_provider.dart';
import 'package:flutter_application_1/widgets/transaction_tile.dart';
import 'package:flutter_application_1/utils/formatters.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final s = context.watch<SettingsProvider>();
    final transacoes = provider.transactions;
    final saldo = provider.balance;
    final receitas = provider.totalIncome;
    final despesas = provider.totalExpense;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final saldoColors = _ResumoColors(
      text: isDark ? Colors.white : Colors.blue.shade700,
      bg: isDark ? const Color(0xFF1A1C1E) : Colors.blue.shade50,
      border: isDark ? Colors.white10 : Colors.blue.shade700.withOpacity(0.2),
    );
    final receitaColors = _ResumoColors(
      text: isDark ? Colors.white : Colors.green.shade700,
      bg: isDark ? const Color(0xFF1A1C1E) : Colors.green.shade50,
      border: isDark ? Colors.white10 : Colors.green.shade700.withOpacity(0.2),
    );
    final despesaColors = _ResumoColors(
      text: isDark ? Colors.white : Colors.red.shade700,
      bg: isDark ? const Color(0xFF1A1C1E) : Colors.red.shade50,
      border: isDark ? Colors.white10 : Colors.red.shade700.withOpacity(0.2),
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          if (s.showBalanceOnHome)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ResumoCard(titulo: 'Saldo', valor: saldo, c: saldoColors),
                _ResumoCard(
                    titulo: 'Receitas', valor: receitas, c: receitaColors),
                _ResumoCard(
                    titulo: 'Despesas', valor: despesas, c: despesaColors),
              ],
            ),
          const Divider(height: 20),
          Expanded(
            child: transacoes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wallet_outlined,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('Nenhuma transação ainda 😅',
                            style: TextStyle(color: Colors.grey, fontSize: 15)),
                        Text('Adicione com o botão +',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: transacoes.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final tx = transacoes[index];
                      return Dismissible(
                        key: ValueKey(tx.id ?? index),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) async {
                          await context
                              .read<TransactionProvider>()
                              .deleteTransaction(tx.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${tx.description} excluída.'),
                                duration: const Duration(seconds: 2)),
                          );
                        },
                        child: TransactionTile(tx: tx, onEdit: () {}),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResumoColors {
  final Color text;
  final Color bg;
  final Color border;
  const _ResumoColors(
      {required this.text, required this.bg, required this.border});
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final double valor;
  final _ResumoColors c;

  const _ResumoCard({
    required this.titulo,
    required this.valor,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: c.text)),
          const SizedBox(height: 5),
          Text(
            formatCurrency(valor, context),
            style: TextStyle(
                color: c.text, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
