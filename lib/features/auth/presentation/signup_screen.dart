import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/auth_repository.dart';
import '../../../core/theme/app_theme.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  int _selectedTab = 0; // 0 for Email, 1 for Phone
  bool _obscurePassword = true;

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty &&
        _passwordController.text.length >= 8;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _birthdayController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_isFormValid || _isLoading) return;
    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );
      if (mounted) context.go('/home');
    } on Exception catch (e) {
      if (mounted) {
        String message = e.toString();
        
        // If account exists, maybe they just need to sign in
        if (message.contains('email-already-in-use')) {
          try {
            // Attempt to auto-login with the same credentials
            await ref.read(authRepositoryProvider).signInWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
            if (mounted) context.go('/home');
            return;
          } catch (signInError) {
            message = "Account exists, but password was incorrect. Please use the 'Signin' link below.";
          }
        } else if (message.contains('no-app')) {
          message = "Firebase not initialized. Please add google-services.json";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Please complete the required\ninformation, and then press the Next\nbutton',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            _buildTabs(),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _emailController,
              hint: 'email@example.com',
              label: 'E-mail',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usernameController,
              hint: 'JohnApple',
              label: 'Username',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _birthdayController,
              hint: '14/08/2020',
              label: 'Birthday',
              icon: Icons.calendar_month_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hint: '••••••••••••',
              label: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: _obscurePassword,
              onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            Text(
              'Password must include a number, a letter, and\na special character.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 48),
            _buildNextButton(),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: const TextStyle(color: Colors.black54),
                children: [
                  TextSpan(
                    text: 'Signin',
                    recognizer: TapGestureRecognizer()..onTap = () => context.go('/login'),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabItem('Email Address', 0),
        const SizedBox(width: 24),
        _buildTabItem('Phone Number', 1),
      ],
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black38,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.fieldBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Icon(icon, color: Colors.blue.withOpacity(0.5), size: 22),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black26, fontSize: 13),
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
              color: Colors.black26, 
              size: 18
            ),
            onPressed: onToggleVisibility,
          ) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isValid = _isFormValid;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: isValid ? [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ] : [],
      ),
      child: ElevatedButton(
        onPressed: isValid && !_isLoading ? _handleSignup : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isValid ? AppTheme.primaryBlue : const Color(0xFFC4C4C4),
          disabledBackgroundColor: const Color(0xFFC4C4C4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: _isLoading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text('Next'),
      ),
    );
  }
}
