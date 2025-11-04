import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  String _currency = 'BRL';
  String _dateFormat = 'dd/MM/yyyy';
  bool _notifications = true;
  bool _biometricLock = false;
  double _monthlyBudget = 0;
  bool _showBalanceOnHome = true;

  bool get darkMode => _darkMode;
  String get currency => _currency;
  String get dateFormat => _dateFormat;
  bool get notifications => _notifications;
  bool get biometricLock => _biometricLock;
  double get monthlyBudget => _monthlyBudget;
  bool get showBalanceOnHome => _showBalanceOnHome;
  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _darkMode = p.getBool('darkMode') ?? false;
    _currency = p.getString('currency') ?? 'BRL';
    _dateFormat = p.getString('dateFormat') ?? 'dd/MM/yyyy';
    _notifications = p.getBool('notifications') ?? true;
    _biometricLock = p.getBool('biometricLock') ?? false;
    _monthlyBudget = p.getDouble('monthlyBudget') ?? 0;
    _showBalanceOnHome = p.getBool('showBalanceOnHome') ?? true;
    notifyListeners();
  }

  void setDarkMode(bool v) {
    if (_darkMode == v) return;
    _darkMode = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setBool('darkMode', v);
    });
  }

  void setCurrency(String v) {
    if (_currency == v) return;
    _currency = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setString('currency', v);
    });
  }

  void setDateFormat(String v) {
    if (_dateFormat == v) return;
    _dateFormat = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setString('dateFormat', v);
    });
  }

  void setNotifications(bool v) {
    if (_notifications == v) return;
    _notifications = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setBool('notifications', v);
    });
  }

  void setBiometricLock(bool v) {
    if (_biometricLock == v) return;
    _biometricLock = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setBool('biometricLock', v);
    });
  }

  void setMonthlyBudget(double v) {
    if (_monthlyBudget == v) return;
    _monthlyBudget = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setDouble('monthlyBudget', v);
    });
  }

  void setShowBalanceOnHome(bool v) {
    if (_showBalanceOnHome == v) return;
    _showBalanceOnHome = v;
    notifyListeners();
    scheduleMicrotask(() async {
      final p = await SharedPreferences.getInstance();
      await p.setBool('showBalanceOnHome', v);
    });
  }

  Future<void> reset() async {
    final p = await SharedPreferences.getInstance();
    _darkMode = false;
    _currency = 'BRL';
    _dateFormat = 'dd/MM/yyyy';
    _notifications = true;
    _biometricLock = false;
    _monthlyBudget = 0;
    _showBalanceOnHome = true;
    await p.setBool('darkMode', _darkMode);
    await p.setString('currency', _currency);
    await p.setString('dateFormat', _dateFormat);
    await p.setBool('notifications', _notifications);
    await p.setBool('biometricLock', _biometricLock);
    await p.setDouble('monthlyBudget', _monthlyBudget);
    await p.setBool('showBalanceOnHome', _showBalanceOnHome);
    notifyListeners();
  }
}
