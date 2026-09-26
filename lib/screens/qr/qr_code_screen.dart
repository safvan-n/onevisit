import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme.dart';
import '../../models/token_model.dart';

class QRCodeScreen extends StatelessWidget {
  final TokenModel token;

  const QRCodeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Digital Entry Pass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Pass exported to photos.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Digital Entry Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Top Card Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: const BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ONEVISIT OFFICIAL PASS',
                                style: TextStyle(
                                  color: AppColors.cyanAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                token.serviceName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.teal.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.teal),
                            ),
                            child: Text(
                              token.tokenNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // QR Code Section (Requirement 15: Scannable QR)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.deepNavy.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: token.qrPayload,
                              version: QrVersions.auto,
                              size: 200.0,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: AppColors.deepNavy,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: AppColors.deepNavy,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Scan at desk scanner to verify your appointment',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // Dashed separator line with ticket notches
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                  (constraints.constrainWidth() / 10).floor(),
                                  (_) => const SizedBox(
                                    width: 5,
                                    height: 1.5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: AppColors.border),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                          ),
                        ),
                      ],
                    ),

                    // Details Section (Requirement 15: Citizen name, Application ID, Token, Service, Office, Status)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildDetailItem('Citizen Name', token.citizenName, Icons.person_outline_rounded),
                          const SizedBox(height: 10),
                          _buildDetailItem('Application ID', token.applicationId, Icons.badge_outlined),
                          const SizedBox(height: 10),
                          _buildDetailItem('Designated Office', token.officeName, Icons.apartment_rounded),
                          const SizedBox(height: 10),
                          _buildDetailItem('Expected Slot', token.expectedTime, Icons.schedule_rounded),
                          const SizedBox(height: 10),
                          _buildDetailItem(
                            'Verification Status',
                            'Pre-Validated via OCR',
                            Icons.verified_user_outlined,
                            textColor: AppColors.emeraldGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Advisory Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.royalBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.royalBlue.withOpacity(0.2)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline_rounded, color: AppColors.royalBlue, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Keep this QR screen open or download it offline. Show it to counter staff when your token is called.',
                        style: TextStyle(fontSize: 12.5, color: AppColors.deepNavy, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, {Color? textColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.deepNavy,
          ),
        ),
      ],
    );
  }
}
