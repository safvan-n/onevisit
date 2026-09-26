import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/notification_model.dart';
import '../../services/app_state.dart';
import '../tokens/live_queue_screen.dart';
import '../applications/applications_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final allNotifications = appState.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              appState.markAllNotificationsAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
            child: const Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.royalBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.royalBlue,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Queue'),
            Tab(text: 'Application'),
            Tab(text: 'System'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationList(allNotifications, appState),
            _buildNotificationList(
              allNotifications.where((n) => n.category == NotificationCategory.queue).toList(),
              appState,
            ),
            _buildNotificationList(
              allNotifications.where((n) => n.category == NotificationCategory.application).toList(),
              appState,
            ),
            _buildNotificationList(
              allNotifications.where((n) => n.category == NotificationCategory.system).toList(),
              appState,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<AppNotification> items, AppState appState) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 54, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'No notifications in this category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notif = items[index];
        IconData icon;
        Color iconColor;

        switch (notif.category) {
          case NotificationCategory.queue:
            icon = Icons.confirmation_number_outlined;
            iconColor = AppColors.royalBlue;
            break;
          case NotificationCategory.application:
            icon = Icons.assignment_outlined;
            iconColor = AppColors.teal;
            break;
          case NotificationCategory.system:
            icon = Icons.info_outline_rounded;
            iconColor = AppColors.emeraldGreen;
            break;
        }

        return Container(
          decoration: BoxDecoration(
            color: notif.isRead ? Colors.white : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notif.isRead ? AppColors.border : AppColors.royalBlue.withOpacity(0.3),
              width: notif.isRead ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              appState.markNotificationAsRead(notif.id);
              if (notif.category == NotificationCategory.queue) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LiveQueueScreen()),
                );
              } else if (notif.category == NotificationCategory.application) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ApplicationsScreen()),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                                color: AppColors.deepNavy,
                              ),
                            ),
                            Text(
                              DateFormat('hh:mm a').format(notif.timestamp),
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.message,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.35),
                        ),
                      ],
                    ),
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
