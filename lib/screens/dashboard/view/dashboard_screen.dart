import 'package:checklist_app/app/config/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.dashboard)),
      body: Center(child: Text(context.l10n.dashboard)),
    );
  }
}
