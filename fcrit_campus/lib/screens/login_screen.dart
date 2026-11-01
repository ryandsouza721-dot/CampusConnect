import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import 'desktop_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _registering = false;
  String _selectedRole = 'STUDENT';
  String? _errorMessage;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = _registering
        ? await ApiService.register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          )
        : await ApiService.login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
          );

    if (!mounted) return;
    setState(() => _loading = false);

    if (result['success'] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DesktopShell()),
      );
    } else {
      setState(() => _errorMessage = result['message'] ?? 'Login failed. Please try again.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 48 : 22,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: wide
                      ? _buildWideLayout(constraints.maxHeight)
                      : _buildLoginCard(compact: true),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(double availableHeight) {
    return Container(
      constraints: BoxConstraints(minHeight: availableHeight - 56),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x140F172A), blurRadius: 48, offset: Offset(0, 20)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(flex: 11, child: _buildWelcomePanel()),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 52),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePanel() {
    return Container(
      padding: const EdgeInsets.all(56),
      decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _brandMark(onDark: true),
              const SizedBox(width: 13),
              const Text(
                'CampusConnect',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                  ),
                  child: const Text('YOUR CAMPUS, CONNECTED', style: TextStyle(color: Colors.white, letterSpacing: 1.2, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Everything campus,\nin one place.',
                  style: TextStyle(color: Colors.white, fontSize: 42, height: 1.12, fontWeight: FontWeight.w700, letterSpacing: -1.2),
                ),
                const SizedBox(height: 18),
                Text(
                  'Stay in the loop with events, notices,\nand the people who make campus yours.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 16, height: 1.65),
                ),
                const SizedBox(height: 38),
                const _FeatureLine(icon: Icons.campaign_outlined, text: 'Important updates, right on time'),
                const SizedBox(height: 15),
                const _FeatureLine(icon: Icons.event_available_outlined, text: 'Discover what’s happening on campus'),
              ],
            ),
          ),
          Text('FCRIT • VASHI', style: TextStyle(color: Colors.white.withValues(alpha: 0.68), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLoginCard({required bool compact}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      padding: EdgeInsets.all(compact ? 26 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x120F172A), blurRadius: 36, offset: Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_brandMark(), const SizedBox(width: 12), const Text('CampusConnect', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 38),
          _buildForm(),
          const SizedBox(height: 28),
          const Center(child: Text('FCRIT • VASHI', style: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Welcome back', style: TextStyle(color: AppColors.textPrimary, fontSize: 30, height: 1.2, fontWeight: FontWeight.w700, letterSpacing: -0.7)),
          const SizedBox(height: 9),
          Text(
            _registering
                ? 'Create your student account to get started.'
                : 'Sign in with your college account to continue.',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          const _FieldLabel('I am signing in as'),
          const SizedBox(height: 10),
          Row(
            children: [
              _roleOption('STUDENT', Icons.school_outlined),
              const SizedBox(width: 8),
              _roleOption('TEACHER', Icons.cast_for_education_outlined),
              const SizedBox(width: 8),
              _roleOption('ADMIN', Icons.admin_panel_settings_outlined),
            ],
          ),
          const SizedBox(height: 24),
          if (_registering) ...[
            const _FieldLabel('Full name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(hint: 'Your name', icon: Icons.person_outline_rounded),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 20),
          ],
          const _FieldLabel('College email'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            decoration: _inputDecoration(hint: 'you@fcrit.ac.in', icon: Icons.mail_outline_rounded),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Enter your college email';
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) return 'Enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 22),
          const _FieldLabel('Password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _loading ? null : _login(),
            decoration: _inputDecoration(
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              if (_registering && value.length < 8) return 'Use at least 8 characters';
              return null;
            },
          ),
          if (_registering) ...[
            const SizedBox(height: 7),
            const Text('Use at least 8 characters.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.urgentBg, borderRadius: BorderRadius.circular(10)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.urgentText, size: 18),
                const SizedBox(width: 9),
                Expanded(child: Text(_errorMessage!, style: const TextStyle(color: AppColors.urgentText, fontSize: 13, height: 1.4))),
              ]),
            ),
          ],
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _login,
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _loading
                  ? const SizedBox(width: 21, height: 21, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_registering ? 'Create student account' : 'Sign in'), const SizedBox(width: 9), const Icon(Icons.arrow_forward_rounded, size: 18)]),
            ),
          ),
          if (_selectedRole == 'STUDENT') ...[
            const SizedBox(height: 18),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(_registering ? 'Already have an account?' : 'New to CampusConnect?', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  TextButton(
                    onPressed: _loading ? null : () => setState(() { _registering = !_registering; _errorMessage = null; _formKey.currentState?.reset(); }),
                    child: Text(_registering ? 'Sign in' : 'Register', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Center(child: Text('Having trouble signing in? Contact your college administrator.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.5))),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
      suffixIcon: suffix,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.urgentRed)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.urgentRed, width: 1.5)),
    );
  }

  Widget _roleOption(String role, IconData icon) {
    final selected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: _loading ? null : () => setState(() {
          _selectedRole = role;
          if (role != 'STUDENT') _registering = false;
          _errorMessage = null;
        }),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.purpleLight : const Color(0xFFFAFAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primaryPurple : AppColors.borderLight, width: selected ? 1.5 : 1),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 20, color: selected ? AppColors.primaryPurple : AppColors.textMuted),
            const SizedBox(height: 5),
            Text(role[0] + role.substring(1).toLowerCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.purpleText : AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }

  Widget _brandMark({bool onDark = false}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.18) : AppColors.purpleLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(Icons.school_rounded, color: onDark ? Colors.white : AppColors.primaryPurple, size: 23),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600));
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: Colors.white, size: 19),
      const SizedBox(width: 12),
      Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
    ]);
  }
}
