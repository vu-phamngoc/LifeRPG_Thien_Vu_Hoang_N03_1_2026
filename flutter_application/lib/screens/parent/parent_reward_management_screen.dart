import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reward_model.dart';
import '../../providers/reward_provider.dart';

class ParentRewardManagementScreen extends StatelessWidget {
  const ParentRewardManagementScreen({super.key});

  Future<void> showRewardDialog(
    BuildContext context, {
    RewardModel? reward,
  }) async {
    final titleController = TextEditingController(text: reward?.title ?? '');
    final descriptionController =
        TextEditingController(text: reward?.description ?? '');
    final priceController =
        TextEditingController(text: reward?.price.toString() ?? '');
    final iconController = TextEditingController(text: reward?.icon ?? '🎁');

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(reward == null ? 'Tạo reward' : 'Sửa reward'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Icon'),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Tên reward'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá coin'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final icon = iconController.text.trim();
                final price = int.tryParse(priceController.text.trim()) ?? 0;

                if (title.isEmpty || description.isEmpty || price <= 0) {
                  return;
                }

                final provider = context.read<RewardProvider>();

                if (reward == null) {
                  await provider.createReward(
                    title: title,
                    description: description,
                    price: price,
                    icon: icon.isEmpty ? '🎁' : icon,
                  );
                } else {
                  await provider.updateReward(
                    rewardId: reward.id,
                    title: title,
                    description: description,
                    price: price,
                    icon: icon.isEmpty ? '🎁' : icon,
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    iconController.dispose();
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

  Widget rewardCard(BuildContext context, RewardModel reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reward.redeemed ? Colors.white : const Color(0xfffff7e8),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: reward.redeemed
              ? const Color(0xfff0e7fb)
              : const Color(0xffffe0a9),
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
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xfffff0cf),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(reward.icon, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    color: Color(0xff2d243b),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward.description,
                  style: const TextStyle(
                    color: Color(0xff8b7c99),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xfffff3df),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${reward.price} ⭐',
                        style: const TextStyle(
                          color: Color(0xffff8a00),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: reward.redeemed
                            ? const Color(0xfff1edf5)
                            : const Color(0xffe7ffe9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        reward.redeemed ? 'Redeemed' : 'Available',
                        style: TextStyle(
                          color: reward.redeemed
                              ? const Color(0xff8b7c99)
                              : const Color(0xff1c9b43),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => showRewardDialog(context, reward: reward),
            icon: const Icon(Icons.edit, color: Color(0xff7048ff)),
          ),
          IconButton(
            onPressed: () {
              context.read<RewardProvider>().deleteReward(reward.id);
            },
            icon: const Icon(Icons.delete, color: Color(0xffd94343)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardProvider = context.watch<RewardProvider>();
    final rewards = rewardProvider.rewards;

    if (rewards.isEmpty) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<RewardProvider>().initRewards();
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton('←', () => Navigator.pop(context)),
                  const Column(
                    children: [
                      Text(
                        'Manage Rewards',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff2d243b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Parent Reward System',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff8b7c99),
                        ),
                      ),
                    ],
                  ),
                  _topButton('➕', () => showRewardDialog(context)),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffff9f43), Color(0xffffb347)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffff9f43).withValues(alpha: 0.28),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Rewards',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${rewards.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Quản lý phần thưởng, tạo reward mới và chỉnh sửa reward cho con.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => showRewardDialog(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xffff8a00),
                      ),
                      child: const Text('Add Reward'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  statCard(
                    icon: '🎁',
                    value: '${rewards.length}',
                    label: 'Rewards',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '✅',
                    value:
                        '${rewards.where((reward) => reward.redeemed).length}',
                    label: 'Redeemed',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '🟢',
                    value:
                        '${rewards.where((reward) => !reward.redeemed).length}',
                    label: 'Available',
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reward Catalog',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff2d243b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage',
                    style: TextStyle(
                      color: Color(0xffff8a00),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (rewards.isEmpty)
                const Text(
                  'Chưa có reward',
                  style: TextStyle(color: Color(0xff8b7c99)),
                )
              else
                Column(
                  children: rewards.map((reward) {
                    return rewardCard(context, reward);
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topButton(String text, VoidCallback onTap) {
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
}
