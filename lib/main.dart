import 'package:flutter/material.dart';
import 'tela_principal.dart';

void main() {
  runApp(MinhasListasApp());
}

class MinhasListasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      title: "Minhas Listas",
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
    );
  }
}