class TransactionModel {
  final int? id;            // null antes de salvar no banco
  final String type;        // "despesa" ou "receita"
  final double value;       // ex: 75.90
  final String description; // ex: "Supermercado"
  final String category;    // ex: "Alimentação"
  final DateTime date;      // quando aconteceu

  TransactionModel({
    this.id,
    required this.type,
    required this.value,
    required this.description,
    required this.category,
    required this.date,
  });

  TransactionModel copyWith({
    int? id,
    String? type,
    double? value,
    String? description,
    String? category,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      type: map['type'] as String,
      value: (map['value'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
