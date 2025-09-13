import 'package:flutter/material.dart';
import 'package:exemplo/core/di/service_locator.dart';
import 'package:exemplo/presentation/pages/pessoas_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.setup();
  runApp(const PessoasApp());
}

class PessoasApp extends StatelessWidget {
  const PessoasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistência Local (SQLite)',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const PessoasPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
