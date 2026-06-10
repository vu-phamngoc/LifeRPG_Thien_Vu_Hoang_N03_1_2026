import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../parent/parent_main_navigation_screen.dart';
import '../child/child_main_navigation_screen.dart';
import '../../providers/task_provider.dart';
import '../../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedRole;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    if (_selectedRole == null) {
      _showMessage('Vui lòng chọn vai trò Parent hoặc Child');
      return;
    }

    if (password.length < 6) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.registerWithEmail(email: email, password: password);

      await UserService().createUserProfile(username: username, phone: phone);

      await UserService().saveUserRoleIfNotExists(_selectedRole!);

      if (_selectedRole == 'child') {
        await UserService().ensureChildDocumentExists();
      }

      if (!mounted) return;

      context.read<TaskProvider>().listenToTasks();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _selectedRole == 'parent'
              ? const ParentMainNavigationScreen()
              : const ChildMainNavigationScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(_getFirebaseErrorMessage(e.code));
    } catch (_) {
      _showMessage('Đăng ký thất bại. Vui lòng thử lại.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'operation-not-allowed':
        return 'Chức năng đăng ký email chưa được bật';
      default:
        return 'Đăng ký thất bại: $code';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _topButton({required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xff2d243b),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required String icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff2d243b),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xfffaf7ff),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xffeee3fb)),
            ),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        color: Color(0xff8b7c99),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                ?suffixIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleOption({
    required String role,
    required String icon,
    required String title,
    required String subtitle,
    required Color activeColor,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: _isLoading
            ? null
            : () {
                setState(() => _selectedRole = role);
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.10)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xffeee3fb),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff502d82).withValues(alpha: 0.06),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff2d243b),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff8b7c99),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  _topButton(
                    icon: Icons.help_outline,
                    onTap: () {
                      _showMessage(
                        'Chọn Parent nếu bạn là phụ huynh, Child nếu bạn là trẻ.',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff7048ff), Color(0xffffb347)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7048ff).withValues(alpha: 0.32),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('⭐', style: TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'KidQuest',
                style: TextStyle(
                  color: Color(0xff2d243b),
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đăng ký tài khoản để bắt đầu\nquản lý nhiệm vụ trẻ em',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff8b7c99),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xfff0e7fb)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff502d82).withValues(alpha: 0.10),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tạo tài khoản',
                      style: TextStyle(
                        color: Color(0xff2d243b),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Chọn vai trò của bạn ngay khi đăng ký.',
                      style: TextStyle(
                        color: Color(0xff8b7c99),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _inputField(
                      label: 'Username',
                      icon: '👤',
                      controller: _usernameController,
                      hintText: 'Nhập tên người dùng',
                    ),
                    _inputField(
                      label: 'Phone',
                      icon: '📱',
                      controller: _phoneController,
                      hintText: 'Nhập số điện thoại',
                      keyboardType: TextInputType.phone,
                    ),
                    _inputField(
                      label: 'Email',
                      icon: '📧',
                      controller: _emailController,
                      hintText: 'Nhập email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _inputField(
                      label: 'Password',
                      icon: '🔒',
                      controller: _passwordController,
                      hintText: 'Nhập mật khẩu',
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xff8b7c99),
                        ),
                      ),
                    ),
                    _inputField(
                      label: 'Confirm Password',
                      icon: '🔐',
                      controller: _confirmPasswordController,
                      hintText: 'Nhập lại mật khẩu',
                      obscureText: !_isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xff8b7c99),
                        ),
                      ),
                    ),
                    const Text(
                      'Đăng ký với vai trò',
                      style: TextStyle(
                        color: Color(0xff2d243b),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _roleOption(
                          role: 'parent',
                          icon: '👨‍👧',
                          title: 'Parent',
                          subtitle: 'Tạo task, xác nhận, quản lý thưởng',
                          activeColor: const Color(0xff7048ff),
                        ),
                        const SizedBox(width: 12),
                        _roleOption(
                          role: 'child',
                          icon: '🧒',
                          title: 'Child',
                          subtitle: 'Làm nhiệm vụ, nhận EXP, lên cấp',
                          activeColor: const Color(0xffff9f43),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _register,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xff7048ff),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'CREATE ACCOUNT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: TextStyle(
                      color: Color(0xff8b7c99),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xff7048ff),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
