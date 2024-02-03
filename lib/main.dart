import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/ui/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
