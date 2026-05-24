import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityProvider>().activities;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử hoạt động'), centerTitle: true),
      body: activities.isEmpty
          ? const Center(child: Text('Chưa có hoạt động'))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(activity.description),

                      const SizedBox(height: 12),

                      Text(
                        activity.createdAt.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
