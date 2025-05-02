class RiderInfo {
  final DateTime availableAt;
  final int estimatedMinutes;

  RiderInfo({
    required this.availableAt,
    required this.estimatedMinutes,
  });

  factory RiderInfo.fromJson(Map<String, dynamic> json) {
    return RiderInfo(
      availableAt: DateTime.parse(json['available_at']),
      estimatedMinutes: json['estimated_minutes'],
    );
  }
} 