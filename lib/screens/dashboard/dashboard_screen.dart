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
    final saldo = provider.balance;
    final receitas = provider.totalIncome;
    final despesas = provider.totalExpense;
    final gastosPorCategoria = provider.expenseByCategory;

    // (Lógica das cores e 'sections' do gráfico - sem alteração)
    final List<Color> chartColors = [
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
      final categoria = entry.value.key;
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
          const Divider(height: 24),

          const Text(
            'Gastos por Categoria',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (despesas == 0 || sections.isEmpty)
                    const AspectRatio(
                      aspectRatio: 1.5,
                      child: Center(
                        child: Text(
                          'Sem dados de despesas para exibir.',
                          style: TextStyle(color: Colors.grey),
                        ),
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
                          texto: '$categoria (${formatCurrency(valor)})',
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}