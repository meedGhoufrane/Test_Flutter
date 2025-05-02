import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/rider_info.dart';
import '../models/delivery_request.dart';

class ApiService {
  final http.Client _client;
  
  // Using mock data flag for development
  final bool _useMockData = true;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<RiderInfo> getNextRiderAvailability() async {
    if (_useMockData) {
      // Return mock data
      return RiderInfo(
        availableAt: DateTime.now().add(const Duration(minutes: 15)),
        estimatedMinutes: 15,
      );
    }
    
    try {
      final response = await _client.get(
        Uri.parse(ApiConfig.nextRiderEndpoint),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RiderInfo.fromJson(data);
      } else {
        throw Exception('Failed to load next rider availability: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data in case of error
      return RiderInfo(
        availableAt: DateTime.now().add(const Duration(minutes: 15)),
        estimatedMinutes: 15,
      );
    }
  }

  Future<bool> requestRider(String clientPhone) async {
    if (_useMockData) {
      // Simulate a successful request
      return true;
    }
    
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.requestRiderEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'client_phone': clientPhone}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<DeliveryRequest>> getDeliveryRequests() async {
    if (_useMockData) {
      // Return mock data
      return [
        DeliveryRequest(
          id: 'req123',
          clientPhone: '0612345678',
          requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
          status: RequestStatus.pending,
        ),
        DeliveryRequest(
          id: 'req124',
          clientPhone: '0687654321',
          requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
          status: RequestStatus.accepted,
        ),
        DeliveryRequest(
          id: 'req125',
          clientPhone: '0611223344',
          requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
          status: RequestStatus.completed,
        ),
        DeliveryRequest(
          id: 'req126',
          clientPhone: '0655667788',
          requestedAt: DateTime.now().subtract(const Duration(hours: 4)),
          status: RequestStatus.cancelled,
        ),
      ];
    }
    
    try {
      final response = await _client.get(
        Uri.parse(ApiConfig.requestsListEndpoint),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DeliveryRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load delivery requests: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data in case of error
      return [
        DeliveryRequest(
          id: 'req123',
          clientPhone: '0612345678',
          requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
          status: RequestStatus.pending,
        ),
        DeliveryRequest(
          id: 'req124',
          clientPhone: '0687654321',
          requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
          status: RequestStatus.completed,
        ),
      ];
    }
  }
} 