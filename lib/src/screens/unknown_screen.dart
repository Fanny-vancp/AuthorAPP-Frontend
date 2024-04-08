import 'package:flutter/material.dart';

class UnknowScreen extends StatelessWidget {
  const UnknowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('404!'),
      ),
    );
  }
}