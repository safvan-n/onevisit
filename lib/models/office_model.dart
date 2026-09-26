class OfficeModel {
  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final int currentQueueCount;
  final int estimatedWaitMinutes;
  final List<String> availableServices;
  final String workingHours;
  final String address;
  final double latitude;
  final double longitude;
  final int totalCounters;
  final int activeCounters;

  const OfficeModel({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.currentQueueCount,
    required this.estimatedWaitMinutes,
    required this.availableServices,
    required this.workingHours,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.totalCounters = 6,
    this.activeCounters = 4,
  });
}

class OfficeRepository {
  static final List<OfficeModel> offices = [
    const OfficeModel(
      id: 'alappuzha_taluk',
      name: 'Alappuzha Taluk Office',
      location: 'Civil Station Ward, Alappuzha',
      distanceKm: 1.8,
      currentQueueCount: 8,
      estimatedWaitMinutes: 25,
      availableServices: ['Ration Card', 'Income Certificate', 'Residence Certificate', 'Voter ID', 'Pension'],
      workingHours: '09:30 AM - 05:00 PM (Mon-Sat)',
      address: 'Taluk Office Complex, Collectorate Road, Alappuzha, Kerala 688001',
      latitude: 9.4981,
      longitude: 76.3388,
      totalCounters: 8,
      activeCounters: 6,
    ),
    const OfficeModel(
      id: 'district_collectorate',
      name: 'District Collectorate & Revenue HQ',
      location: 'Collectorate Junction, Alappuzha',
      distanceKm: 2.3,
      currentQueueCount: 14,
      estimatedWaitMinutes: 40,
      availableServices: ['Revenue', 'Certificates', 'Pension', 'Government', 'Passport Services'],
      workingHours: '10:00 AM - 05:00 PM (Mon-Fri)',
      address: 'Collectorate Campus, NH 66, Alappuzha, Kerala 688001',
      latitude: 9.5012,
      longitude: 76.3421,
      totalCounters: 10,
      activeCounters: 7,
    ),
    const OfficeModel(
      id: 'rto_alappuzha',
      name: 'Regional Transport Office (RTO)',
      location: 'Boat Jetty Road, Alappuzha',
      distanceKm: 3.1,
      currentQueueCount: 19,
      estimatedWaitMinutes: 50,
      availableServices: ['Driving Licence', 'Transport', 'Vehicle Registration'],
      workingHours: '09:00 AM - 04:30 PM (Mon-Fri)',
      address: 'Near KSRTC Bus Stand, Boat Jetty Rd, Alappuzha 688011',
      latitude: 9.4912,
      longitude: 76.3298,
      totalCounters: 6,
      activeCounters: 5,
    ),
    const OfficeModel(
      id: 'akshaya_centre_central',
      name: 'Akshaya e-Kendra Model Center',
      location: 'Near Town Hall, Alappuzha',
      distanceKm: 0.9,
      currentQueueCount: 4,
      estimatedWaitMinutes: 12,
      availableServices: ['PAN Card', 'Aadhaar', 'Ration Card', 'Voter ID', 'Certificates'],
      workingHours: '08:30 AM - 07:00 PM (Mon-Sat)',
      address: 'Shop 14, Municipal Shopping Complex, Town Hall Road, Alappuzha',
      latitude: 9.4934,
      longitude: 76.3345,
      totalCounters: 4,
      activeCounters: 3,
    ),
    const OfficeModel(
      id: 'city_municipality',
      name: 'City Municipal Corporation',
      location: 'Palace Road, Alappuzha',
      distanceKm: 2.7,
      currentQueueCount: 11,
      estimatedWaitMinutes: 30,
      availableServices: ['Municipality Services', 'Birth Certificate', 'Death Certificate', 'Trade License'],
      workingHours: '10:00 AM - 05:00 PM (Mon-Sat)',
      address: 'Municipal Bhavan, Palace Road, Alappuzha 688001',
      latitude: 9.5050,
      longitude: 76.3312,
      totalCounters: 7,
      activeCounters: 5,
    ),
  ];
}
