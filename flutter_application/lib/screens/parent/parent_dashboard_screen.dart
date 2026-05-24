import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard'), centerTitle: true),
      body: const Center(child: Text('Màn hình quản lý của phụ huynh')),
    );
  }
}
