import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/application_model.dart';
import '../../services/app_state.dart';
import 'application_detail_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final allApps = appState.applications;

    final activeApps = allApps
        .where((a) =>
            a.status == ApplicationStatus.submitted ||
            a.status == ApplicationStatus.underReview ||
            a.status == ApplicationStatus.approved ||
            a.status == ApplicationStatus.draft)
        .toList();

    final completedApps = allApps
        .where((a) => a.status == ApplicationStatus.completed)
        .toList();

    final cancelledApps = allApps
        .where((a) => a.status == ApplicationStatus.rejected)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Applications'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.royalBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.royalBlue,
          tabs: [
            Tab(text: 'Active (${activeApps.length})'),
            Tab(text: 'Completed (${completedApps.length})'),
            Tab(text: 'Cancelled (${cancelledApps.length})'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildApplicationList(activeApps),
            _buildApplicationList(completedApps),
            _buildApplicationList(cancelledApps),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationList(List<ApplicationModel> apps) {
    if (apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 54, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'No applications in this category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: apps.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final app = apps[index];
        Color statusColor;
        switch (app.status) {
          case ApplicationStatus.approved:
          case ApplicationStatus.completed:
            statusColor = AppColors.emeraldGreen;
            break;
          case ApplicationStatus.underReview:
            statusColor = AppColors.warning;
            break;
          case ApplicationStatus.rejected:
            statusColor = AppColors.danger;
            break;
          default:
            statusColor = AppColors.royalBlue;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ApplicationDetailScreen(application: app),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          app.formattedStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(app.id, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(app.createdAt),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                app.officeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
