import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  Widget topButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget statCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xfff0e7fb)),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xff2d243b),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff8b7c99),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chip(String text, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xff7048ff) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? const Color(0xff7048ff) : const Color(0xffeee3fb),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xff7d708d),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget activityCard({
    required String icon,
    required String title,
    required String description,
    required String tag,
    required String time,
    required String amount,
    required Color iconBg,
    bool featured = false,
    bool positive = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: featured ? const Color(0xfffff7e8) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: featured ? const Color(0xffffe0a9) : const Color(0xfff0e7fb),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff2d243b),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xff8b7c99),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffe7ffe9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xff1c9b43),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xffaaa0b5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: positive
                  ? const Color(0xff1c9b43)
                  : const Color(0xffff8a00),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityProvider>().activities;

    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        topButton('←', () => Navigator.pop(context)),
                        const Column(
                          children: [
                            Text(
                              'Activity',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xff2d243b),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Lịch sử hoạt động',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff8b7c99),
                              ),
                            ),
                          ],
                        ),
                        topButton('⚙️', () {}),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff7048ff), Color(0xff9d72ff)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today Summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${activities.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Hoạt động hôm nay bao gồm task, EXP, reward và achievement.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        statCard(icon: '📋', value: '6', label: 'Tasks'),
                        const SizedBox(width: 12),
                        statCard(icon: '⭐', value: '180', label: 'EXP'),
                        const SizedBox(width: 12),
                        statCard(icon: '🎁', value: '2', label: 'Rewards'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xffeee3fb)),
                      ),
                      child: const Row(
                        children: [
                          Text('🔍', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Text(
                            'Tìm task, reward, achievement...',
                            style: TextStyle(
                              color: Color(0xff8b7c99),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          chip('All', active: true),
                          const SizedBox(width: 10),
                          chip('Task'),
                          const SizedBox(width: 10),
                          chip('EXP'),
                          const SizedBox(width: 10),
                          chip('Reward'),
                          const SizedBox(width: 10),
                          chip('Achievement'),
                          const SizedBox(width: 10),
                          chip('Rejected'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Timeline',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff2d243b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Export',
                          style: TextStyle(
                            color: Color(0xff7048ff),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          color: Color(0xff8b7c99),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (activities.isEmpty)
                      activityCard(
                        icon: '📘',
                        title: 'Homework Approved',
                        description: 'Phụ huynh đã xác nhận nhiệm vụ Homework.',
                        tag: 'APPROVED',
                        time: '09:30 AM',
                        amount: '+50 EXP',
                        iconBg: const Color(0xfff1e9ff),
                      )
                    else
                      Column(
                        children: activities.map((activity) {
                          return activityCard(
                            icon: '📋',
                            title: activity.title,
                            description: activity.description,
                            tag: 'ACTIVITY',
                            time: 'Just now',
                            amount: '+0 EXP',
                            iconBg: const Color(0xfff1e9ff),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: 92,
              decoration: const BoxDecoration(
                color: Color(0xfffff8ff),
                border: Border(top: BorderSide(color: Color(0xffeadff4))),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomItem(icon: '🏠', label: 'Home'),
                  _BottomItem(icon: '📊', label: 'Content', active: true),
                  _BottomItem(icon: 'ℹ️', label: 'About'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;

  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(icon, style: const TextStyle(fontSize: 27)),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xff7048ff) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
