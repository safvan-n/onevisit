import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../models/token_model.dart';
import '../../services/app_state.dart';
import '../qr/qr_code_screen.dart';

class LiveQueueScreen extends StatelessWidget {
  const LiveQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeToken = appState.activeToken;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Queue Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Queue',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Queue state synchronized with office server.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: activeToken == null || activeToken.status == TokenStatus.cancelled
            ? _buildEmptyTokenState(context)
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Office Status Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.royalBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.apartment_rounded, color: AppColors.royalBlue, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeToken.officeName,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.deepNavy),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activeToken.serviceName,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: activeToken.status == TokenStatus.serving
                                  ? AppColors.emeraldGreen
                                  : activeToken.status == TokenStatus.active
                                      ? AppColors.royalBlue.withOpacity(0.12)
                                      : AppColors.softGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activeToken.status == TokenStatus.serving
                                  ? 'YOUR TURN'
                                  : 'ACTIVE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: activeToken.status == TokenStatus.serving
                                    ? Colors.white
                                    : AppColors.royalBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Real-Time Queue Monitor Card (Requirement 14: Now Serving, User Token, People Ahead, Counter)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: activeToken.status == TokenStatus.serving
                            ? const LinearGradient(
                                colors: [Color(0xFF047857), Color(0xFF059669)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [AppColors.deepNavy, Color(0xFF133B6A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepNavy.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
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
                                    AppLocalization.tr('nowServing', appState.language).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    activeToken.nowServingToken,
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.cyanAccent,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalization.tr('yourToken', appState.language).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    activeToken.tokenNumber,
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text('People Ahead', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${activeToken.peopleAhead}',
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 26, color: Colors.white24),
                                Column(
                                  children: [
                                    const Text('Est. Turn Time', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${activeToken.estimatedWaitMinutes} mins',
                                      style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 26, color: Colors.white24),
                                Column(
                                  children: [
                                    const Text('Counter', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                                    const SizedBox(height: 4),
                                    Text(
                                      activeToken.counterNumber,
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Turn Announcement Banner
                    if (activeToken.status == TokenStatus.serving)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.emeraldGreen, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volume_up_rounded, color: AppColors.emeraldGreen, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'NOW CALLING YOUR TOKEN!',
                                    style: TextStyle(
                                      color: AppColors.emeraldGreen,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Please proceed immediately to ${activeToken.counterNumber} with your digital QR pass.',
                                    style: const TextStyle(fontSize: 12.5, color: AppColors.deepNavy),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (activeToken.peopleAhead <= 2)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.directions_walk_rounded, color: AppColors.warning, size: 26),
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'You are next in line! Please make your way toward the counter waiting hall.',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Interactive Simulator Controls
                    Container(
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
                            children: const [
                              Icon(Icons.bolt_rounded, color: AppColors.royalBlue, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Live Queue Simulation (Interactive)',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.deepNavy),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Click the button below to test how the queue advances, updates wait time, and triggers notifications in real time:',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                appState.progressQueue();
                              },
                              icon: const Icon(Icons.fast_forward_rounded, size: 18),
                              label: const Text('Simulate Next Token Called'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons (Requirement 13: View QR Code, Cancel Token)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => QRCodeScreen(token: activeToken),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                            label: const Text('View QR Pass', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.royalBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            _showCancelDialog(context, appState);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: AppColors.danger, size: 18),
                          label: const Text('Cancel Token', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.danger),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Active Token?'),
        content: const Text(
          'Are you sure you want to surrender your slot? You will have to book a fresh token.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Token'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.cancelActiveToken();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Confirm Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTokenState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.confirmation_number_outlined, size: 54, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Active Token',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
            ),
            const SizedBox(height: 8),
            const Text(
              'You currently do not have any pending government office tokens.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Book a Digital Token'),
            ),
          ],
        ),
      ),
    );
  }
}
