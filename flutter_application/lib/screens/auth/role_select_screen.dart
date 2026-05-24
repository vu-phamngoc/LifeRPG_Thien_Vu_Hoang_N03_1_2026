import 'package:flutter/material.dart';

import '../parent/parent_dashboard_screen.dart';
import '../child/child_home_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn vai trò'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bạn muốn sử dụng ứng dụng với vai trò nào?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentDashboardScreen(),
                    ),
                  );
                },
                child: const Text('Phụ huynh'),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ChildHomeScreen()),
                  );
                },
                child: const Text('Trẻ em'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
