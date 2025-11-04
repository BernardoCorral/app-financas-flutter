import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('Aparência'),
          Selector<SettingsProvider, bool>(
            selector: (_, p) => p.darkMode,
            builder: (context, darkMode, _) => SwitchListTile(
              title: const Text('Tema escuro'),
              value: darkMode,
              onChanged: context.read<SettingsProvider>().setDarkMode,
            ),
          ),
          const SizedBox(height: 16),
          const _SectionHeader('Preferências'),
          Selector<SettingsProvider, String>(
            selector: (_, p) => p.currency,
            builder: (context, currency, _) => DropdownButtonFormField<String>(
              initialValue: currency,
              decoration: const InputDecoration(
                labelText: 'Moeda',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'BRL', child: Text('BRL • Real')),
                DropdownMenuItem(value: 'USD', child: Text('USD • Dólar')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR • Euro')),
              ],
              onChanged: (v) {
                if (v != null) context.read<SettingsProvider>().setCurrency(v);
              },
            ),
          ),
          const SizedBox(height: 12),
          Selector<SettingsProvider, String>(
            selector: (_, p) => p.dateFormat,
            builder: (context, dateFormat, _) =>
                DropdownButtonFormField<String>(
              initialValue: dateFormat,
              decoration: const InputDecoration(
                labelText: 'Formato de data',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'dd/MM/yyyy', child: Text('dd/MM/yyyy')),
                DropdownMenuItem(
                    value: 'MM/dd/yyyy', child: Text('MM/dd/yyyy')),
                DropdownMenuItem(
                    value: 'yyyy-MM-dd', child: Text('yyyy-MM-dd')),
              ],
              onChanged: (v) {
                if (v != null)
                  context.read<SettingsProvider>().setDateFormat(v);
              },
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 16),
          const _SectionHeader('Financeiro'),
          Selector<SettingsProvider, double>(
            selector: (_, p) => p.monthlyBudget,
            builder: (context, monthlyBudget, _) => TextFormField(
              initialValue:
                  monthlyBudget == 0 ? '' : monthlyBudget.toStringAsFixed(2),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Meta mensal',
                hintText: 'Ex.: 2500.00',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                context.read<SettingsProvider>().setMonthlyBudget(parsed);
              },
            ),
          ),
          const SizedBox(height: 16),
          const _SectionHeader('Privacidade e notificações'),
          Selector<SettingsProvider, bool>(
            selector: (_, p) => p.notifications,
            builder: (context, notifications, _) => SwitchListTile(
              title: const Text('Notificações'),
              value: notifications,
              onChanged: context.read<SettingsProvider>().setNotifications,
            ),
          ),
          Selector<SettingsProvider, bool>(
            selector: (_, p) => p.biometricLock,
            builder: (context, biometricLock, _) => SwitchListTile(
              title: const Text('Bloqueio por biometria'),
              value: biometricLock,
              onChanged: context.read<SettingsProvider>().setBiometricLock,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
