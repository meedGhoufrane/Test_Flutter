import 'package:flutter/material.dart';
import '../models/delivery_request.dart';
import '../services/api_service.dart';
import '../widgets/request_form_dialog.dart';
import '../widgets/request_list_item.dart';
import '../widgets/success_notification.dart';

class CommandsScreen extends StatefulWidget {
  const CommandsScreen({super.key});

  @override
  State<CommandsScreen> createState() => _CommandsScreenState();
}

class _CommandsScreenState extends State<CommandsScreen> {
  final ApiService _apiService = ApiService();
  List<DeliveryRequest> _activeRequests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadActiveRequests();
  }

  Future<void> _loadActiveRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final requests = await _apiService.getDeliveryRequests();
      
      if (mounted) {
        setState(() {
          // Only show pending and accepted requests (active)
          _activeRequests = requests.where((request) => 
            request.status == RequestStatus.pending || 
            request.status == RequestStatus.accepted
          ).toList();
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
          'Commande créée avec succès!',
        );
        _loadActiveRequests();
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
        onRefresh: _loadActiveRequests,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRequestDialog,
        backgroundColor: const Color(0xFF1A73E8),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_activeRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 64,
              color: Color(0xFF1A73E8),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune commande active',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showRequestDialog,
              icon: const Icon(Icons.add),
              label: const Text('NOUVELLE COMMANDE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
      children: [
        const Text(
          'Commandes actives',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          _activeRequests.length,
          (index) => RequestListItem(request: _activeRequests[index]),
        ),
      ],
    );
  }
} 