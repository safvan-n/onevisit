import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/service_model.dart';
import '../../models/office_model.dart';
import '../../models/application_model.dart';
import '../../models/token_model.dart';
import '../../services/app_state.dart';
import '../qr/qr_code_screen.dart';
import 'live_queue_screen.dart';

class TokenBookingScreen extends StatefulWidget {
  final ServiceItem service;
  final OfficeModel? office;
  final ApplicationModel? linkedApplication;

  const TokenBookingScreen({
    super.key,
    required this.service,
    this.office,
    this.linkedApplication,
  });

  @override
  State<TokenBookingScreen> createState() => _TokenBookingScreenState();
}

class _TokenBookingScreenState extends State<TokenBookingScreen> {
  late OfficeModel _selectedOffice;
  DateTime _selectedDate = DateTime.now();
  String _selectedSlot = '11:30 AM - 12:00 PM';
  bool _isBooking = false;

  final List<String> _timeSlots = [
    '09:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '02:00 PM - 02:30 PM',
    '02:30 PM - 03:00 PM',
    '03:30 PM - 04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedOffice = widget.office ?? OfficeRepository.offices.first;
  }

  void _handleBookToken() {
    setState(() => _isBooking = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);

      final dateStr = DateFormat('dd MMM yyyy').format(_selectedDate);
      final newToken = appState.bookToken(
        serviceName: widget.service.name,
        officeName: _selectedOffice.name,
        officeAddress: _selectedOffice.address,
        expectedTime: '$_selectedSlot ($dateStr)',
        linkedAppId: widget.linkedApplication?.id,
      );

      setState(() => _isBooking = false);

      _showSuccessDialog(newToken);
    });
  }

  void _showSuccessDialog(TokenModel token) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.emeraldGreen, size: 48),
                ),
                const SizedBox(height: 16),
                const Text(
                  '✓ Token Booked Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your appointment has been reserved in the official queue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Token Details Card (Requirement 12)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text('YOUR DIGITAL TOKEN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text(
                        token.tokenNumber,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.royalBlue,
                        ),
                      ),
                      const Divider(height: 20),
                      _detailRow('Office', token.officeName),
                      const SizedBox(height: 6),
                      _detailRow('Service', token.serviceName),
                      const SizedBox(height: 6),
                      _detailRow('Date', DateFormat('dd MMMM yyyy').format(token.bookedDate)),
                      const SizedBox(height: 6),
                      _detailRow('Slot', token.expectedTime),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons: View QR Code, Add to Calendar, Track Queue (Requirement 12)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LiveQueueScreen()),
                      );
                    },
                    icon: const Icon(Icons.sensors_rounded, size: 18),
                    label: const Text('Track Queue Live', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.royalBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => QRCodeScreen(token: token)),
                          );
                        },
                        icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                        label: const Text('View QR Code', style: TextStyle(fontSize: 12.5)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment added to your device calendar.')),
                          );
                        },
                        icon: const Icon(Icons.calendar_month_outlined, size: 16),
                        label: const Text('Add Calendar', style: TextStyle(fontSize: 12.5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Digital Token'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Summary Card (Requirement 12)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepNavy.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: widget.service.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(widget.service.icon, color: widget.service.color, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SELECTED SERVICE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                    Text(
                                      widget.service.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),

                          Row(
                            children: [
                              const Icon(Icons.apartment_rounded, color: AppColors.royalBlue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('OFFICE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                    Text(
                                      _selectedOffice.name,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                                    ),
                                    Text(
                                      _selectedOffice.location,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Live Queue & Estimated Wait
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.softGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.groups_rounded, size: 16, color: AppColors.royalBlue),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Queue: ${_selectedOffice.currentQueueCount} citizens',
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 20, color: AppColors.border),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.emeraldGreen),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Wait: ~${_selectedOffice.estimatedWaitMinutes} min',
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date Selection
                    const Text(
                      'Select Appointment Date',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 84,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(Duration(days: index));
                          final isSelected = date.day == _selectedDate.day;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDate = date),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 68,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.royalBlue : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.royalBlue : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? AppColors.royalBlue.withOpacity(0.25)
                                        : Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('E').format(date).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: isSelected ? Colors.white : AppColors.deepNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Time Slot Selection
                    const Text(
                      'Select Preferred Time Slot',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _timeSlots.map((slot) {
                        final isSelected = slot == _selectedSlot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedSlot = slot);
                          },
                          selectedColor: AppColors.teal,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.deepNavy,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12.5,
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? AppColors.teal : AppColors.border,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Submit Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isBooking ? null : _handleBookToken,
                  icon: const Icon(Icons.confirmation_number_rounded),
                  label: _isBooking
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Book Digital Token', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
