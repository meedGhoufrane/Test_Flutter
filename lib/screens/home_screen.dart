import 'package:flutter/material.dart';
import '../models/delivery_request.dart';
import '../models/rider_info.dart';
import '../services/api_service.dart';
import '../widgets/rider_availability_card.dart';
import '../widgets/request_form_dialog.dart';
import '../widgets/request_list_item.dart';
import '../widgets/success_notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  RiderInfo? _riderInfo;
  List<DeliveryRequest> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final riderInfo = await _apiService.getNextRiderAvailability();
      final requests = await _apiService.getDeliveryRequests();
      
      if (mounted) {
        setState(() {
          _riderInfo = riderInfo;
          _requests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur de chargement des données: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => RequestFormDialog(
        onSubmit: _requestRider,
      ),
    );
  }

  Future<void> _requestRider(String phoneNumber) async {
    try {
      final success = await _apiService.requestRider(phoneNumber);
      
      if (success && mounted) {
        SuccessNotification.show(
          context,
          'Demande de livreur envoyée avec succès!',
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: const Color(0xFFF44336),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rider availability card
          if (_riderInfo != null)
            RiderAvailabilityCard(
              riderInfo: _riderInfo!,
              onRequestRider: _showRequestDialog,
            ),
          
          // Request history title
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              'Historique des demandes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Delivery requests list
          _requests.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Aucune demande de livraison'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    return RequestListItem(request: _requests[index]);
                  },
                ),
          
          // Bottom padding
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
} 