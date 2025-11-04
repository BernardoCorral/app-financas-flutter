// lib/utils/formatters.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/settings_provider.dart';

String formatDate(DateTime date, [BuildContext? context]) {
  final fmt = context?.read<SettingsProvider>().dateFormat ?? 'dd/MM/yyyy';
  return DateFormat(fmt).format(date);
}

String currencySymbol(BuildContext context) {
  final code = context.read<SettingsProvider>().currency;
  return _symbolFor(code);
}

String formatCurrency(double value, [BuildContext? context]) {
  final code = context?.read<SettingsProvider>().currency ?? 'BRL';
  final locale = _localeFor(code);
  final symbol = _symbolFor(code);
  final NumberFormat formatter =
      NumberFormat.currency(locale: locale, symbol: symbol);
  return formatter.format(value);
}

String _localeFor(String code) {
  switch (code) {
    case 'USD':
      return 'en_US';
    case 'EUR':
      return 'de_DE';
    case 'GBP':
      return 'en_GB';
    case 'CAD':
      return 'en_CA';
    case 'BRL':
    default:
      return 'pt_BR';
  }
}

String _symbolFor(String code) {
  switch (code) {
    case 'USD':
      return r'$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'CAD':
      return r'$';
    case 'BRL':
    default:
      return 'R\$';
  }
}
