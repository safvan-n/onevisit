import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/app_state.dart';

class StaffCounterScreen extends StatefulWidget {
  const StaffCounterScreen({super.key});

  @override
  State<StaffCounterScreen> createState() => _StaffCounterScreenState();
}

class _StaffCounterScreenState extends State<StaffCounterScreen> {
  final String _selectedCounter = 'C-03';
  String _currentToken = 'A-097';
  String _nextToken = 'A-098';

  final List<String> _pendingQueue = [
    'A-098',
    'A-099',
    'A-100',
    'A-101',
    'A-102 (Rahul Nair)',
    'A-103',
  ];

  void _callNextToken(AppState appState) {
    if (_pendingQueue.isNotEmpty) {
      setState(() {
        _currentToken = _pendingQueue.removeAt(0).split(' ')[0];
        _nextToken = _pendingQueue.isNotEmpty ? _pendingQueue[0].split(' ')[0] : 'None';
      });

      // Synchronize with citizen state live!
      appState.staffCallNext(_selectedCounter);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.royalBlue,
          content: Text('Calling Token $_currentToken to Counter 03...'),
        ),
      );
    }
  }

  void _completeToken(AppState appState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emeraldGreen,
        content: Text('Token $_currentToken marked completed.'),
      ),
    );
    appState.staffCompleteToken(_selectedCounter);
    _callNextToken(appState);
  }

  void _skipToken() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.warning,
        content: Text('Token $_currentToken skipped. Placed on re-call list.'),
      ),
    );
  }

  void _holdToken() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.deepNavy,
        content: Text('Token $_currentToken held on counter for 10 minutes.'),
      ),
    );
  }

  void _scanCitizenQR(AppState appState) {
    // Show QR scanning modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.qr_code_scanner_rounded, color: AppColors.royalBlue, size: 28),
                  SizedBox(width: 12),
                  Text('Desk QR Code Scanner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Hold citizen mobile pass in front of terminal camera or select instant test citizen:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Camera Viewfinder Box Simulation
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cyanAccent, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.filter_center_focus_rounded, size: 54, color: AppColors.cyanAccent),
                      SizedBox(height: 8),
                      Text('Target Citizen QR Pass', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trigger Simulated Scan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _showScannedCitizenPass(appState);
                  },
                  icon: const Icon(Icons.verified_rounded),
                  label: const Text('Simulate Scan Citizen QR (Rahul Nair A-102)', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.royalBlue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showScannedCitizenPass(AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_rounded, color: AppColors.emeraldGreen, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Citizen Verified', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
                      Text('Official records match Aadhaar vault', style: TextStyle(fontSize: 11.5, color: AppColors.emeraldGreen)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              _passRow('Citizen Name', appState.userName),
              _passRow('Token Number', 'A-102 (Current Slot)'),
              _passRow('Application ID', 'APP-2026-RC8821'),
              _passRow('Service', 'Ration Card (PHH Priority)'),
              _passRow('Address', appState.userAddress),
              _passRow('Documents', '3 OCR Pre-Verified Attachments'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.emeraldGreen,
                            content: Text('Application APP-2026-RC8821 endorsed and approved!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldGreen),
                      child: const Text('Endorse & Approve'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          Expanded(child: Text(val, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.deepNavy))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Staff Counter Terminal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan Citizen QR',
            onPressed: () => _scanCitizenQR(appState),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Counter Header Card (Requirement 24)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'COUNTER TERMINAL ACTIVE',
                          style: TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.emeraldGreen, borderRadius: BorderRadius.circular(6)),
                          child: const Text('ONLINE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Counter 03 - Voter ID & Civil Supplies',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Officer: Priya Das • Taluk Office Complex',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Now Serving & Next Token Displays (Requirement 24)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.royalBlue, width: 2),
                        boxShadow: [
                          BoxShadow(color: AppColors.royalBlue.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CURRENT TOKEN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(
                            _currentToken,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.royalBlue),
                          ),
                          const Text('At Counter Desk', style: TextStyle(fontSize: 11.5, color: AppColors.emeraldGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('NEXT IN QUEUE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(
                            _nextToken,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.deepNavy),
                          ),
                          const Text('Waiting in Lobby', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Counter Action Buttons (Requirement 24: Call Next, Complete, Skip, Hold)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Counter Calling Operations', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () => _callNextToken(appState),
                            icon: const Icon(Icons.campaign_rounded, size: 20),
                            label: const Text('Call Next Token', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.royalBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () => _completeToken(appState),
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            label: const Text('Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emeraldGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _skipToken,
                            icon: const Icon(Icons.skip_next_rounded, size: 18),
                            label: const Text('Skip Absent'),
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _holdToken,
                            icon: const Icon(Icons.pause_circle_outline, size: 18),
                            label: const Text('Hold (10m)'),
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Staff QR Scanner Quick Bar (Requirement 24)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.teal.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.teal, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Scan Citizen QR Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.deepNavy)),
                          SizedBox(height: 2),
                          Text('Inspect validated application and OCR docs', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _scanCitizenQR(appState),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: const Text('Scan QR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Pending Queue List (Requirement 24)
              const Text(
                'Upcoming Citizens in Queue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 10),
              ..._pendingQueue.map((tkn) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 16, color: AppColors.royalBlue),
                          const SizedBox(width: 10),
                          Text(
                            tkn,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.deepNavy),
                          ),
                        ],
                      ),
                      const Text('Ready', style: TextStyle(fontSize: 12, color: AppColors.emeraldGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
