import 'package:checklist_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(const CheckListApp());
}
