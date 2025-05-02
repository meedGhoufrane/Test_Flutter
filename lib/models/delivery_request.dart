enum RequestStatus {
  pending,
  accepted,
  completed,
  cancelled,
}

extension RequestStatusExtension on RequestStatus {
  String get name {
    switch (this) {
      case RequestStatus.pending:
        return 'En attente';
      case RequestStatus.accepted:
        return 'Accepté';
      case RequestStatus.completed:
        return 'Terminé';
      case RequestStatus.cancelled:
        return 'Annulé';
    }
  }
}

class DeliveryRequest {
  final String id;
  final String clientPhone;
  final DateTime requestedAt;
  final RequestStatus status;

  DeliveryRequest({
    required this.id,
    required this.clientPhone,
    required this.requestedAt,
    required this.status,
  });

  factory DeliveryRequest.fromJson(Map<String, dynamic> json) {
    return DeliveryRequest(
      id: json['id'],
      clientPhone: json['client_phone'],
      requestedAt: DateTime.parse(json['requested_at']),
      status: _parseStatus(json['status']),
    );
  }

  static RequestStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }
} 