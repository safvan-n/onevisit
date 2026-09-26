import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/office_model.dart';
import '../../services/app_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings_rounded, color: AppColors.deepNavy),
            SizedBox(width: 8),
            Text('Admin Portal'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.royalBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.royalBlue,
          tabs: const [
            Tab(text: 'Analytics'),
            Tab(text: 'Queue Counters'),
            Tab(text: 'Offices'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAnalyticsTab(appState),
            _buildQueueCountersTab(appState),
            _buildOfficesTab(),
          ],
        ),
      ),
    );
  }

  // Analytics Tab (Requirement 23: Total Citizens, Today's Applications, Active Tokens, Completed Services, Avg Wait)
  Widget _buildAnalyticsTab(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Performance Metrics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 12),

          // Stat Cards Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _buildStatCard('Total Citizens', '14,289', Icons.people_alt_rounded, AppColors.royalBlue),
              _buildStatCard("Today's Apps", '382', Icons.assignment_turned_in_rounded, AppColors.teal),
              _buildStatCard('Active Tokens', '46', Icons.confirmation_number_rounded, AppColors.warning),
              _buildStatCard('Completed', '336', Icons.check_circle_rounded, AppColors.emeraldGreen),
            ],
          ),
          const SizedBox(height: 12),

          // Full-width Avg Wait Time Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('AVERAGE WAITING TIME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
                    SizedBox(height: 4),
                    Text('14.2 Minutes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('Down 68% from physical queues', style: TextStyle(fontSize: 11.5, color: Color(0xFFD1FAE5))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.speed_rounded, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Analytics Charts Simulation: Peak Hours & Most Used Services
          const Text(
            'Peak Hours Distribution',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildHourlyBar('09:00 - 11:00 AM', 0.85, '120 visits', AppColors.royalBlue),
                const SizedBox(height: 8),
                _buildHourlyBar('11:00 - 01:00 PM', 0.95, '148 visits (Peak)', AppColors.teal),
                const SizedBox(height: 8),
                _buildHourlyBar('02:00 - 03:30 PM', 0.60, '74 visits', AppColors.emeraldGreen),
                const SizedBox(height: 8),
                _buildHourlyBar('03:30 - 05:00 PM', 0.40, '40 visits', AppColors.royalBlue),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Most-Used Citizen Services',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildServiceRankRow('1', 'Ration Card Modifications', '34% of volume', AppColors.emeraldGreen),
                const Divider(height: 16),
                _buildServiceRankRow('2', 'Revenue & Income Certificates', '28% of volume', AppColors.royalBlue),
                const Divider(height: 16),
                _buildServiceRankRow('3', 'Voter ID Electoral Form 6/8', '21% of volume', AppColors.teal),
                const Divider(height: 16),
                _buildServiceRankRow('4', 'Driving Licence Renewals', '17% of volume', AppColors.deepNavy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Queue Management Tab (Requirement 23: Create counter, Assign service, Call next, Skip, Cancel)
  Widget _buildQueueCountersTab(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Counters (4)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showCreateCounterDialog();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Counter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...appState.counters.map((c) {
            final isActive = c['status'] == 'ACTIVE';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.deepNavy,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              c['id'],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c['name'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.emeraldGreen.withOpacity(0.12) : AppColors.softGrey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c['status'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isActive ? AppColors.emeraldGreen : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Assigned Service: ${c['service']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  Text('Desk Staff: ${c['staff']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const Divider(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Now Serving', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                          Text(c['currentToken'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.royalBlue)),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              appState.staffCallNext(c['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Called next token for ${c['name']}')),
                              );
                            },
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                            child: const Text('Call Next', style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 6),
                          OutlinedButton(
                            onPressed: () {
                              appState.staffCompleteToken(c['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Marked current token as completed on ${c['name']}')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.emeraldGreen,
                              side: const BorderSide(color: AppColors.emeraldGreen),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text('Complete', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Office Management Tab (Requirement 23: Add office, Edit office, Manage services)
  Widget _buildOfficesTab() {
    final offices = OfficeRepository.offices;

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: offices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final office = offices[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      office.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.deepNavy),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Editing configuration for ${office.name}...')),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              Text(office.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _badge('${office.activeCounters} Active Counters', AppColors.royalBlue),
                  const SizedBox(width: 8),
                  _badge('${office.currentQueueCount} in Queue', AppColors.teal),
                  const SizedBox(width: 8),
                  _badge('~${office.estimatedWaitMinutes}m Wait', AppColors.emeraldGreen),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildHourlyBar(String hour, double fraction, String visits, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(hour, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
            Text(visits, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor: AppColors.softGrey,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRankRow(String rank, String name, String share, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(rank, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
        ),
        Text(share, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: color)),
    );
  }

  void _showCreateCounterDialog() {
    final nameController = TextEditingController(text: 'Counter 05');
    final staffController = TextEditingController(text: 'Kavita Pillai');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service Counter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Counter Name')),
            const SizedBox(height: 10),
            TextField(controller: staffController, decoration: const InputDecoration(labelText: 'Assigned Staff Officer')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.emeraldGreen,
                  content: Text('New counter created and assigned.'),
                ),
              );
            },
            child: const Text('Create Counter'),
          ),
        ],
      ),
    );
  }
}
