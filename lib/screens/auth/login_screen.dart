import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../services/app_state.dart';
import '../main_shell.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: 'rahul.nair@citizen.gov.in');
  final _passwordController = TextEditingController(text: 'Password@123');
  bool _obscurePassword = true;
  bool _isOtpMode = false;
  final _otpController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.login(_identifierController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  void _loginAsRole(UserRole role) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setRole(role);
    appState.login('demo@onevisit.gov.in', 'Demo123');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Brand Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Image.asset(AppConstants.logoAsset, height: 75),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('One', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                        Text('Visit', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.teal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      AppConstants.tagline,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    _isOtpMode ? 'Sign in with OTP' : 'Welcome Back',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isOtpMode
                        ? 'Enter your mobile number to receive 6-digit OTP'
                        : 'Access your citizen services, queue tokens, and applications',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Method Switch Tabs (Password / OTP)
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isOtpMode = false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_isOtpMode ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: !_isOtpMode
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                  color: !_isOtpMode ? AppColors.royalBlue : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isOtpMode = true),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isOtpMode ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _isOtpMode
                                    ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'OTP Verification',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                  color: _isOtpMode ? AppColors.royalBlue : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Identifier field
                  TextFormField(
                    controller: _identifierController,
                    decoration: InputDecoration(
                      labelText: _isOtpMode ? 'Mobile Number' : 'Mobile Number or Email',
                      prefixIcon: Icon(_isOtpMode ? Icons.phone_android_rounded : Icons.person_outline_rounded),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter your mobile number or email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password or OTP field
                  if (!_isOtpMode) ...[
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset link sent to your registered email.')),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.royalBlue, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter 6-digit OTP',
                        prefixIcon: const Icon(Icons.lock_clock_outlined),
                        suffix: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('New OTP sent: 123456')),
                            );
                          },
                          child: const Text('Resend OTP', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Login Button
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Login to OneVisit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Google Login Button
                  OutlinedButton.icon(
                    onPressed: () {
                      final appState = Provider.of<AppState>(context, listen: false);
                      appState.login('google.user@gmail.com', 'GoogleAuth');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                      );
                    },
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.royalBlue),
                    label: const Text('Continue with Google / DigiLocker', style: TextStyle(fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.royalBlue, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Fast Switcher for Staff & Admin Demo Testing
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ Quick Role Switcher (For Evaluation)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _loginAsRole(UserRole.citizen),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                                child: const Text('Citizen Mode', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _loginAsRole(UserRole.staff),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                                child: const Text('Staff Counter', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _loginAsRole(UserRole.admin),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                                child: const Text('Admin Panel', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
