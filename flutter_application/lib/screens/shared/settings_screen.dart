import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        tileColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  Widget buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: value,
        onChanged: (_) {},
        secondary: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        tileColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
      appBar: AppBar(title: const Text('Cài đặt'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Tài khoản'),
            buildSettingItem(
              icon: Icons.person,
              title: 'Thông tin cá nhân',
              subtitle: 'Quản lý tên, email và hồ sơ người dùng',
            ),
            buildSettingItem(
              icon: Icons.family_restroom,
              title: 'Quản lý gia đình',
              subtitle: 'Quản lý phụ huynh và trẻ em trong hệ thống',
            ),

            buildSectionTitle('Ứng dụng'),
            buildSwitchItem(
              icon: Icons.notifications,
              title: 'Thông báo',
              subtitle: 'Nhắc nhiệm vụ, xác nhận và phần thưởng',
              value: true,
            ),
            buildSwitchItem(
              icon: Icons.dark_mode,
              title: 'Chế độ tối',
              subtitle: 'Bật giao diện tối cho ứng dụng',
              value: false,
            ),
            buildSettingItem(
              icon: Icons.language,
              title: 'Ngôn ngữ',
              subtitle: 'Tiếng Việt',
            ),

            buildSectionTitle('Gamification'),
            buildSettingItem(
              icon: Icons.star,
              title: 'Quy tắc EXP / Level',
              subtitle: 'Thiết lập điểm kinh nghiệm và cấp độ',
            ),
            buildSettingItem(
              icon: Icons.card_giftcard,
              title: 'Quy tắc Reward',
              subtitle: 'Thiết lập coin, thưởng và đổi quà',
            ),
            buildSettingItem(
              icon: Icons.emoji_events,
              title: 'Achievement',
              subtitle: 'Quản lý điều kiện mở khóa thành tựu',
            ),

            buildSectionTitle('Dữ liệu'),
            buildSettingItem(
              icon: Icons.cloud_sync,
              title: 'Đồng bộ dữ liệu',
              subtitle: 'Chuẩn bị kết nối Firebase / Cloud Firestore',
            ),
            buildSettingItem(
              icon: Icons.backup,
              title: 'Sao lưu',
              subtitle: 'Sao lưu dữ liệu nhiệm vụ và lịch sử',
            ),

            buildSectionTitle('Khác'),
            buildSettingItem(
              icon: Icons.info,
              title: 'Giới thiệu ứng dụng',
              subtitle: 'Life RPG - Gamified Task Management',
            ),
            buildSettingItem(
              icon: Icons.logout,
              title: 'Đăng xuất',
              subtitle: 'Đăng xuất khỏi tài khoản hiện tại',
              onTap: () async {
                await AuthService().logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
