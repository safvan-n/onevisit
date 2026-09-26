import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../models/service_model.dart';
import '../../models/token_model.dart';
import '../../services/app_state.dart';
import '../services/services_screen.dart';
import '../tokens/live_queue_screen.dart';
import '../tokens/token_booking_screen.dart';
import '../forms/guided_form_screen.dart';
import '../qr/qr_code_screen.dart';
import '../notifications/notifications_screen.dart';
import '../applications/application_detail_screen.dart';

class HomeDashboard extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeDashboard({super.key, required this.onTabChange});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Government', 'icon': Icons.account_balance_rounded, 'color': AppColors.royalBlue},
    {'name': 'Healthcare', 'icon': Icons.local_hospital_rounded, 'color': AppColors.emeraldGreen},
    {'name': 'Education', 'icon': Icons.school_rounded, 'color': Color(0xFF0284C7)},
    {'name': 'Police', 'icon': Icons.local_police_rounded, 'color': AppColors.deepNavy},
    {'name': 'Municipality', 'icon': Icons.location_city_rounded, 'color': AppColors.teal},
    {'name': 'Transport', 'icon': Icons.directions_car_rounded, 'color': Color(0xFF3B82F6)},
    {'name': 'Revenue', 'icon': Icons.receipt_long_rounded, 'color': Color(0xFFF59E0B)},
    {'name': 'Pension', 'icon': Icons.elderly_rounded, 'color': Color(0xFF8B5CF6)},
    {'name': 'Certificates', 'icon': Icons.verified_user_rounded, 'color': Color(0xFF10B981)},
    {'name': 'More', 'icon': Icons.grid_view_rounded, 'color': AppColors.deepNavy},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeToken = appState.activeToken;
    final recentApps = appState.applications;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile & Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.royalBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'RN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalization.tr('goodMorning', appState.language),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            appState.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepNavy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepNavy.withOpacity(0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.deepNavy,
                            size: 22,
                          ),
                        ),
                      ),
                      if (appState.unreadNotificationCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${appState.unreadNotificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ServicesScreen(initialQuery: query.trim()),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalization.tr('searchPlaceholder', appState.language),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.royalBlue),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
                      onPressed: () => widget.onTabChange(1),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.deepNavy, Color(0xFF0F3E6D), Color(0xFF09687E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -25,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(AppConstants.logoAsset, height: 130),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.teal.withOpacity(0.4)),
                              ),
                              child: const Text(
                                'OFFICIAL CITIZEN PORTAL',
                                style: TextStyle(
                                  color: AppColors.cyanAccent,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalization.tr('bannerTitle', appState.language),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppLocalization.tr('bannerSubtitle', appState.language),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => widget.onTabChange(1),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('Explore All Services', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming / Active Token Section (Requirement 4)
              if (activeToken != null && activeToken.status != TokenStatus.cancelled) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: AppColors.royalBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.tr('activeToken', appState.language),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => widget.onTabChange(2),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.royalBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.royalBlue.withOpacity(0.3), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalBlue.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeToken.serviceName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    activeToken.officeName,
                                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text('TOKEN', style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold)),
                                Text(
                                  activeToken.tokenNumber,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Now Serving', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              Text(
                                activeToken.nowServingToken,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.teal),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 28, color: AppColors.border),
                          Column(
                            children: [
                              const Text('People Ahead', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              Text(
                                '${activeToken.peopleAhead}',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 28, color: AppColors.border),
                          Column(
                            children: [
                              const Text('Est. Wait', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              Text(
                                '${activeToken.estimatedWaitMinutes} min',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const LiveQueueScreen()),
                                );
                              },
                              icon: const Icon(Icons.sensors_rounded, size: 18),
                              label: const Text('Live Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.royalBlue,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => QRCodeScreen(token: activeToken),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                            label: const Text('QR Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Quick Actions
              Text(
                AppLocalization.tr('quickActions', appState.language),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickActionButton(
                    icon: Icons.search_rounded,
                    label: AppLocalization.tr('findService', appState.language),
                    color: AppColors.royalBlue,
                    onTap: () => widget.onTabChange(1),
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.edit_note_rounded,
                    label: AppLocalization.tr('fillForm', appState.language),
                    color: AppColors.teal,
                    onTap: () {
                      final firstService = ServiceRepository.services.first;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GuidedFormScreen(service: firstService),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.add_alarm_rounded,
                    label: AppLocalization.tr('bookToken', appState.language),
                    color: AppColors.emeraldGreen,
                    onTap: () {
                      final firstService = ServiceRepository.services.first;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TokenBookingScreen(service: firstService),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildQuickActionButton(
                    icon: Icons.confirmation_number_outlined,
                    label: AppLocalization.tr('myTokens', appState.language),
                    color: AppColors.deepNavy,
                    onTap: () => widget.onTabChange(2),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categories (All 10 required categories)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.tr('categories', appState.language),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onTabChange(1),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.royalBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ServicesScreen(initialCategory: cat['name']),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: (cat['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: (cat['color'] as Color).withOpacity(0.2)),
                            ),
                            child: Icon(cat['icon'], color: cat['color'], size: 28),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepNavy,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Recent Applications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.tr('recentApplications', appState.language),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onTabChange(3),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.royalBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recentApps.take(2).length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final app = recentApps[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepNavy.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.softGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.description_outlined, color: AppColors.royalBlue),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.serviceName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  app.id,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ApplicationDetailScreen(application: app),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.softGrey,
                            foregroundColor: AppColors.deepNavy,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            app.formattedStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: app.formattedStatus == 'Approved'
                                  ? AppColors.emeraldGreen
                                  : app.formattedStatus == 'Under Review'
                                      ? AppColors.warning
                                      : AppColors.royalBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
