import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/transaction_provider.dart';
import 'screens/transactions/transactions_list_screen.dart';
import 'screens/transactions/transaction_form_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider()..loadMonth(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Finanças',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          background: const Color(0xFFF6F8F2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F2),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade200,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // rota inicial
      initialRoute: '/',

      // registrando TODAS as rotas nomeadas usadas no app
      routes: {
        '/': (context) => const TransactionsListScreen(),
        '/transaction-form': (context) => const TransactionFormScreen(),
        // mais pra frente:
        // '/dashboard': (_) => const DashboardScreen(),
        // '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
