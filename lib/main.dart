import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/transaction_provider.dart';
import 'providers/settings_provider.dart';

import 'screens/transactions/transactions_list_screen.dart';
import 'screens/transactions/transaction_form_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
            create: (_) => TransactionProvider()..loadMonth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Minhas Finanças',
      debugShowCheckedModeBanner: false,
      themeMode: s.themeMode,
      themeAnimationDuration: Duration.zero,
      themeAnimationCurve: Curves.linear,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F2),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: Colors.white,
        dividerColor: const Color(0xFFE5E7EB),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade200,
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.highContrastDark(
          primary: Colors.greenAccent.shade400,
          secondary: Colors.tealAccent.shade400,
          surface: const Color.fromARGB(255, 42, 44, 46),
          error: Colors.redAccent,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 28, 30, 32),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: const Color(0xFF1A1C1E),
        dividerColor: const Color(0xFF2C2D30),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/transaction-form': (context) => const TransactionFormScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    TransactionsListScreen(),
    DashboardScreen(),
    SettingsScreen(),
  ];

  static const List<String> _titles = <String>[
    'Minhas Transações',
    'Dashboard',
    'Configurações',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles.elementAt(_selectedIndex),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: cs.surface,
        elevation: 8,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withOpacity(0.65),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Transações'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Configurações'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/transaction-form'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
