class OwnerRequest {
  final int id;
  final String name;
  final String details;
  final String? brtaCertificateScan;
  final String? nationalIdScan;
  final String? businessRegistrationScan;

  OwnerRequest({
    required this.id,
    required this.name,
    required this.details,
    this.brtaCertificateScan,
    this.nationalIdScan,
    this.businessRegistrationScan,
  });

  factory OwnerRequest.fromJson(Map<String, dynamic> json) {
    return OwnerRequest(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      details: json['details'] ?? 'No details available',
      brtaCertificateScan: json['brta_certificate_scan'],
      nationalIdScan: json['national_id_scan'],
      businessRegistrationScan: json['business_registration_scan'],
    );
  }
}