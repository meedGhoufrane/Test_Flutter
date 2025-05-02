import 'package:flutter/material.dart';
import '../models/delivery_request.dart';
import '../utils/date_formatter.dart';

class RequestListItem extends StatelessWidget {
  final DeliveryRequest request;

  const RequestListItem({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: _getStatusIcon(),
        title: Text(
          'Client: ${request.clientPhone}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Demandé le: ${DateFormatter.formatDateTime(request.requestedAt)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Chip(
          label: Text(
            _getStatusText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: _getStatusColor(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        ),
      ),
    );
  }

  Widget _getStatusIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        _getStatusIconData(),
        color: _getStatusColor(),
        size: 20,
      ),
    );
  }

  IconData _getStatusIconData() {
    switch (request.status) {
      case RequestStatus.pending:
        return Icons.access_time;
      case RequestStatus.accepted:
        return Icons.delivery_dining;
      case RequestStatus.completed:
        return Icons.check_circle;
      case RequestStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText() {
    switch (request.status) {
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

  Color _getStatusColor() {
    switch (request.status) {
      case RequestStatus.pending:
        return const Color(0xFFFF9800); // Orange
      case RequestStatus.accepted:
        return const Color(0xFF1A73E8); // Blue
      case RequestStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case RequestStatus.cancelled:
        return const Color(0xFFF44336); // Red
    }
  }
} 