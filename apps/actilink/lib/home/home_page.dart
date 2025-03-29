import 'package:flutter/material.dart';
import 'base_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: const Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
