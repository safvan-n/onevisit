import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../services/app_state.dart';
import 'home/home_dashboard.dart';
import 'services/services_screen.dart';
import 'tokens/live_queue_screen.dart';
import 'applications/applications_screen.dart';
import 'profile/profile_screen.dart';
import 'settings/accessibility_screen.dart';
import 'staff/staff_counter_screen.dart';
import 'admin/admin_dashboard.dart';

class MainShell extends StatefulWidget {
  final int initialTab;

  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final List<Widget> pages = [
      HomeDashboard(onTabChange: _onTabTapped),
      const ServicesScreen(),
      const LiveQueueScreen(),
      const ApplicationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            AppConstants.logoAsset,
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 44,
        title: Row(
          children: [
            Text('One', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.deepNavy, fontSize: 19)),
            Text('Visit', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.teal, fontSize: 19)),
          ],
        ),
        actions: [
          // Quick Role Badge / Portal Switcher
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: PopupMenuButton<UserRole>(
              tooltip: 'Switch Portal Mode',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      appState.currentRole == UserRole.admin
                          ? Icons.admin_panel_settings_rounded
                          : appState.currentRole == UserRole.staff
                              ? Icons.desktop_windows_rounded
                              : Icons.person_rounded,
                      size: 16,
                      color: AppColors.royalBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appState.currentRole == UserRole.admin
                          ? 'Admin'
                          : appState.currentRole == UserRole.staff
                              ? 'Staff'
                              : 'Citizen',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
              onSelected: (role) {
                appState.setRole(role);
                if (role == UserRole.staff) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StaffCounterScreen()),
                  );
                } else if (role == UserRole.admin) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: UserRole.citizen,
                  child: Row(
                    children: [
                      Icon(Icons.person_outline_rounded, color: AppColors.royalBlue, size: 18),
                      SizedBox(width: 8),
                      Text('Citizen Portal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: UserRole.staff,
                  child: Row(
                    children: [
                      Icon(Icons.desktop_windows_rounded, color: AppColors.teal, size: 18),
                      SizedBox(width: 8),
                      Text('Staff Calling Counter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: UserRole.admin,
                  child: Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: AppColors.deepNavy, size: 18),
                      SizedBox(width: 8),
                      Text('Admin Management', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Accessibility / Language Shortcut
          IconButton(
            icon: const Icon(Icons.translate_rounded, color: AppColors.deepNavy, size: 20),
            tooltip: 'Language & Accessibility',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AccessibilityScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepNavy.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.royalBlue,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppLocalization.tr('navHome', appState.language),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_rounded),
              activeIcon: const Icon(Icons.grid_view_sharp),
              label: AppLocalization.tr('navServices', appState.language),
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.confirmation_number_outlined),
                  if (appState.activeToken != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.emeraldGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.confirmation_number_rounded),
              label: AppLocalization.tr('navTokens', appState.language),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              activeIcon: const Icon(Icons.assignment_rounded),
              label: AppLocalization.tr('navApps', appState.language),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: AppLocalization.tr('navProfile', appState.language),
            ),
          ],
        ),
      ),
    );
  }
}
