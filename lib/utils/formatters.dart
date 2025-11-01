import 'package:intl/intl.dart';

// Se der erro de import do intl, adiciona no pubspec.yaml:
// intl: ^0.19.0
// e roda flutter pub get

String formatDate(DateTime date) {
  // Ex: 01/11/2025
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatCurrency(double value) {
  // Ex: R$ 75,90
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  return formatter.format(value);
}
