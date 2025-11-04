import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/formatters.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String _type = "despesa";
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = "Alimentação";
  DateTime _date = DateTime.now();

  final List<String> _categories = [
    "Alimentação",
    "Transporte",
    "Lazer",
    "Salário",
    "Mercado",
    "Outros",
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState?.validate() != true) return;

    final value = double.tryParse(
      _valueController.text.replaceAll(',', '.'),
    );

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Valor inválido")),
      );
      return;
    }

    final newTx = TransactionModel(
      type: _type,
      value: value,
      description: _descriptionController.text.trim(),
      category: _category,
      date: _date,
    );

    await context.read<TransactionProvider>().addTransaction(newTx);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>(); // re-render em alterações de settings
    final isDespesa = _type == "despesa";
    final symbol = currencySymbol(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nova Transação",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tipo",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    selected: _type == "despesa",
                    label: const Text("Despesa"),
                    selectedColor: Colors.red[100],
                    onSelected: (_) {
                      setState(() {
                        _type = "despesa";
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selected: _type == "receita",
                    label: const Text("Receita"),
                    selectedColor: Colors.green[100],
                    onSelected: (_) {
                      setState(() {
                        _type = "receita";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Valor",
                  prefixText: isDespesa ? "- $symbol " : "+ $symbol ",
                  border: const OutlineInputBorder(),
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return "Informe um valor";
                  }
                  final num? v = num.tryParse(text.replaceAll(',', '.'));
                  if (v == null || v <= 0) {
                    return "Valor inválido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  hintText: "Ex: Mercado do fim de semana",
                  border: OutlineInputBorder(),
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return "Informe uma descrição";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: "Categoria",
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Data",
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(_date, context)),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Salvar"),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
