import 'package:flutter/material.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Profile'), centerTitle: true),
      body: const Center(
        child: Text('Thông tin phụ huynh', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
