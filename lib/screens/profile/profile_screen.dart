import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/app_state.dart';
import '../auth/login_screen.dart';
import 'documents_wallet_screen.dart';
import '../settings/accessibility_screen.dart';
import '../support/help_support_screen.dart';
import '../notifications/notifications_screen.dart';
import '../admin/admin_dashboard.dart';
import '../staff/staff_counter_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Citizen Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Profile Card Header (Requirement 19)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.royalBlue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'RN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            appState.userPhone,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appState.userEmail,
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Staff & Admin Mode Quick Navigation (Requirement 23 & 24)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F3156), Color(0xFF095A6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.admin_panel_settings_rounded, color: AppColors.cyanAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'OFFICE & STAFF TERMINALS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Access the live government counter terminal to call tokens, scan citizen QR passes, or inspect admin throughput.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const StaffCounterScreen()),
                              );
                            },
                            icon: const Icon(Icons.desktop_windows_rounded, size: 16),
                            label: const Text('Staff Counter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                              );
                            },
                            icon: const Icon(Icons.analytics_outlined, size: 16),
                            label: const Text('Admin Portal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.deepNavy,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Options Menu (Requirement 19: All listed items)
              _buildMenuSection(
                title: 'Citizen Identity & Wallet',
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    subtitle: 'Full name, gender, DOB, marital status',
                    onTap: () {
                      _showPersonalInfoDialog(context, appState);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.folder_special_outlined,
                    title: 'My Documents (Vault)',
                    subtitle: 'Secure locker for Aadhaar, PAN, DL proofs',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DocumentsWalletScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Civil Station, Alappuzha - 688001',
                    onTap: () {
                      _showAddressDialog(context, appState);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildMenuSection(
                title: 'App Preferences & Accessibility',
                children: [
                  _buildMenuItem(
                    icon: Icons.translate_rounded,
                    title: 'Language & Accessibility',
                    subtitle: 'Malayalam, English, Hindi, Large text, Voice',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AccessibilityScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications & Alerts',
                    subtitle: 'Queue turn alerts, push notifications',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Security & PIN',
                    subtitle: 'Biometrics, OTP lock, Login credentials',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Two-factor authentication is active on +91 98471 23456.')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildMenuSection(
                title: 'Support & Legal',
                children: [
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    subtitle: 'FAQ, Toll-Free, Live AI Assistant',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Citizen Privacy Policy',
                    subtitle: 'Data protection as per Digital DPDP Act',
                    onTap: () {
                      _showPolicyDialog(context, 'Citizen Privacy Policy', 'OneVisit operates under national citizen data protection frameworks. All scanned documents are encrypted on device and securely transmitted to authorized department gateways.');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.gavel_outlined,
                    title: 'Terms & Conditions',
                    subtitle: 'Government electronic service agreement',
                    onTap: () {
                      _showPolicyDialog(context, 'Terms & Conditions', 'By using OneVisit, citizens agree to authentic declarations. False information submitted to government portals is subject to statutory verification.');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Logout Button (Requirement 19)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    appState.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                  label: const Text('Logout from OneVisit', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
          ),
        ),
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.deepNavy, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.deepNavy)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }

  void _showPersonalInfoDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dialogRow('Full Name', appState.userName),
            _dialogRow('Phone', appState.userPhone),
            _dialogRow('Email', appState.userEmail),
            _dialogRow('Aadhaar ID', appState.userAadhaar),
            _dialogRow('Residence', appState.userAddress),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saved Citizen Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Primary Domicile Address:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Text(appState.userAddress, style: const TextStyle(fontSize: 13, color: AppColors.deepNavy)),
            const SizedBox(height: 12),
            const Text('District: Alappuzha | Taluk: Ambalappuzha', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Done')),
        ],
      ),
    );
  }

  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content, style: const TextStyle(fontSize: 13.5, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Understood')),
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
        ],
      ),
    );
  }
}
