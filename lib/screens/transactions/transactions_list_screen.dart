import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/widgets/transaction_tile.dart';
import 'package:flutter_application_1/utils/formatters.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transacoes = provider.transactions;
    final saldo = provider.balance;
    final receitas = provider.totalIncome;
    final despesas = provider.totalExpense;


    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ResumoCard(
                titulo: 'Saldo',
                valor: saldo,
                corTexto: Colors.blue.shade700,
                corFundo: Colors.blue.shade50,
              ),
              _ResumoCard(
                titulo: 'Receitas',
                valor: receitas,
                corTexto: Colors.green.shade700,
                corFundo: Colors.green.shade50,
              ),
              _ResumoCard(
                titulo: 'Despesas',
                valor: despesas,
                corTexto: Colors.red.shade700,
                corFundo: Colors.red.shade50,
              ),
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
                        Text(
                          'Nenhuma transação ainda 😅',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          'Adicione com o botão +',
                          style: TextStyle(color: Colors.grey),
                        ),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete,
                              color: Colors.white),
                        ),
                        onDismissed: (_) async {
                          await context
                              .read<TransactionProvider>()
                              .deleteTransaction(tx.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${tx.description} excluída.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: TransactionTile(
                          tx: tx,
                          onEdit: () {
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final double valor;
  final Color corTexto;
  final Color corFundo;

  const _ResumoCard({
    required this.titulo,
    required this.valor,
    required this.corTexto,
    required this.corFundo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: corTexto.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: corTexto)),
          const SizedBox(height: 5),
          Text(
            formatCurrency(valor),
            style: TextStyle(
              color: corTexto,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}