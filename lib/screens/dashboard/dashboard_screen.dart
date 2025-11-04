import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/utils/formatters.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final despesas = provider.totalExpense;
    final gastosPorCategoria = provider.expenseByCategory;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> chartColors = isDark
        ? [
            const Color(0xFF81C784),
            const Color(0xFF64B5F6),
            const Color(0xFFE57373),
            const Color(0xFFFFB74D),
            const Color(0xFFBA68C8),
            const Color(0xFF4DB6AC),
            const Color(0xFFA1887F),
            const Color(0xFFF06292),
          ]
        : [
            Colors.blue,
            Colors.red,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.brown,
            Colors.teal,
            Colors.pink,
          ];

    final List<PieChartSectionData> sections =
        gastosPorCategoria.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final valor = entry.value.value;
      final percentual = despesas > 0 ? (valor / despesas) * 100 : 0.0;

      return PieChartSectionData(
        color: chartColors[index % chartColors.length],
        value: valor,
        title: '${percentual.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        showTitle: percentual > 5,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ResumoCard(kind: _ResumoKind.saldo),
              _ResumoCard(kind: _ResumoKind.receitas),
              _ResumoCard(kind: _ResumoKind.despesas),
            ],
          ),
          const Divider(height: 24),
          const Text('Gastos por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (despesas == 0 || sections.isEmpty)
                    const AspectRatio(
                      aspectRatio: 1.5,
                      child: Center(
                        child: Text('Sem dados de despesas para exibir.',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 3,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  if (sections.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: gastosPorCategoria.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final categoria = entry.value.key;
                        final valor = entry.value.value;
                        return _LegendaItem(
                          color: chartColors[index % chartColors.length],
                          texto:
                              '$categoria (${formatCurrency(valor, context)})',
                        );
                      }).toList(),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ResumoKind { saldo, receitas, despesas }

class _ResumoCard extends StatelessWidget {
  final _ResumoKind kind;
  const _ResumoCard({required this.kind});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorMap = {
      _ResumoKind.saldo: isDark ? Colors.white : Colors.blue.shade700,
      _ResumoKind.receitas: isDark ? Colors.white : Colors.green.shade700,
      _ResumoKind.despesas: isDark ? Colors.white : Colors.red.shade700,
    };
    final bg = isDark
        ? const Color(0xFF1A1C1E)
        : {
            _ResumoKind.saldo: Colors.blue.shade50,
            _ResumoKind.receitas: Colors.green.shade50,
            _ResumoKind.despesas: Colors.red.shade50,
          }[kind]!;

    final titulo = {
      _ResumoKind.saldo: 'Saldo',
      _ResumoKind.receitas: 'Receitas',
      _ResumoKind.despesas: 'Despesas',
    }[kind]!;

    final valor = {
      _ResumoKind.saldo: provider.balance,
      _ResumoKind.receitas: provider.totalIncome,
      _ResumoKind.despesas: provider.totalExpense,
    }[kind]!;

    return Container(
      width: 175,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white10 : colorMap[kind]!.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: colorMap[kind]!)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatCurrency(valor, context),
              style: TextStyle(
                color: colorMap[kind]!,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendaItem extends StatelessWidget {
  final Color color;
  final String texto;

  const _LegendaItem({required this.color, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}
