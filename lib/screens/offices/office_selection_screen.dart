import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/service_model.dart';
import '../../models/office_model.dart';
import '../../models/application_model.dart';
import '../tokens/token_booking_screen.dart';

class OfficeSelectionScreen extends StatefulWidget {
  final ServiceItem service;
  final ApplicationModel? linkedApplication;
  final bool isDirectBooking;

  const OfficeSelectionScreen({
    super.key,
    required this.service,
    this.linkedApplication,
    this.isDirectBooking = false,
  });

  @override
  State<OfficeSelectionScreen> createState() => _OfficeSelectionScreenState();
}

class _OfficeSelectionScreenState extends State<OfficeSelectionScreen> {
  bool _isMapView = false;
  String _searchQuery = '';
  OfficeModel? _selectedOffice;

  @override
  void initState() {
    super.initState();
    _selectedOffice = OfficeRepository.offices.first;
  }

  @override
  Widget build(BuildContext context) {
    final filteredOffices = OfficeRepository.offices.where((o) {
      return _searchQuery.isEmpty ||
          o.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Office'),
        actions: [
          // View Switcher (Map / List)
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.list_alt_rounded,
                      color: !_isMapView ? AppColors.royalBlue : AppColors.textMuted, size: 20),
                  tooltip: 'List View',
                  onPressed: () => setState(() => _isMapView = false),
                ),
                IconButton(
                  icon: Icon(Icons.map_outlined,
                      color: _isMapView ? AppColors.royalBlue : AppColors.textMuted, size: 20),
                  tooltip: 'Map View',
                  onPressed: () => setState(() => _isMapView = true),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Selected Service Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.service.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.service.icon, color: widget.service.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Official Center For:',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        Text(
                          widget.service.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.linkedApplication != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.linkedApplication!.id,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldGreen,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Search taluk office, corporation, center...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.royalBlue),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
              ),
            ),

            // Main Content: List View or Interactive Map View
            Expanded(
              child: _isMapView
                  ? _buildInteractiveMapView(filteredOffices)
                  : _buildListView(filteredOffices),
            ),

            // Bottom Continue Button
            if (_selectedOffice != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: AppColors.border)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepNavy.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedOffice!.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${_selectedOffice!.distanceKm} km away',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                              Text(
                                '${_selectedOffice!.currentQueueCount} in queue (${_selectedOffice!.estimatedWaitMinutes}m)',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.emeraldGreen),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TokenBookingScreen(
                              service: widget.service,
                              office: _selectedOffice!,
                              linkedApplication: widget.linkedApplication,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.royalBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Proceed to Token', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Interactive Map View Graphic (Requirement 11: Map View)
  Widget _buildInteractiveMapView(List<OfficeModel> offices) {
    return Stack(
      children: [
        // Realistic Styled Map Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFE2EAF2),
          child: CustomPaint(
            painter: _MapCanvasPainter(),
          ),
        ),

        // Office Pin Markers on Map
        ...offices.asMap().entries.map((entry) {
          final idx = entry.key;
          final office = entry.value;
          final isSelected = _selectedOffice?.id == office.id;

          // Compute realistic distributed positions
          final double left = 60.0 + (idx % 3) * 110.0;
          final double top = 90.0 + (idx * 90.0);

          return Positioned(
            left: left,
            top: top,
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedOffice = office);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.deepNavy : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      office.name.split(' ').take(2).join(' '),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.deepNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.royalBlue : AppColors.teal,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Floating Tip Badge
        Positioned(
          top: 16,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.touch_app_rounded, size: 16, color: AppColors.royalBlue),
                SizedBox(width: 6),
                Text(
                  'Tap on any office pin marker to view queue details',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Standard Clean List View (Requirement 11: List View)
  Widget _buildListView(List<OfficeModel> offices) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      itemCount: offices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final office = offices[index];
        final isSelected = _selectedOffice?.id == office.id;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedOffice = office);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.royalBlue : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.royalBlue.withOpacity(0.1)
                      : AppColors.deepNavy.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.royalBlue.withOpacity(0.12)
                            : AppColors.softGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        color: isSelected ? AppColors.royalBlue : AppColors.deepNavy,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            office.name,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  office.location,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${office.distanceKm} km',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.royalBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Metrics Row: Current Queue, Est Wait, Counters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_alt_outlined, size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Queue: ${office.currentQueueCount} citizens',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 15, color: AppColors.emeraldGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Wait: ~${office.estimatedWaitMinutes} min',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.meeting_room_outlined, size: 15, color: AppColors.teal),
                        const SizedBox(width: 6),
                        Text(
                          '${office.activeCounters}/${office.totalCounters} Counters',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Available services tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: office.availableServices.take(3).map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter to render roads and geography on map canvas
class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final highwayPaint = Paint()
      ..color = const Color(0xFFFDE68A)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final riverPaint = Paint()
      ..color = const Color(0xFF93C5FD).withOpacity(0.5)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    // River
    final riverPath = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width, size.height * 0.6);
    canvas.drawPath(riverPath, riverPaint);

    // Main Highway
    final highwayPath = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.8, size.height);
    canvas.drawPath(highwayPath, highwayPaint);

    // Cross roads
    final roadPath = Path()
      ..moveTo(0, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.25)
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.7);
    canvas.drawPath(roadPath, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
