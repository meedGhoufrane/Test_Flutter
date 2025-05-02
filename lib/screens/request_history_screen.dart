import 'package:flutter/material.dart';
import '../models/delivery_request.dart';
import '../services/api_service.dart';
import '../widgets/request_list_item.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key});

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  final ApiService _apiService = ApiService();
  List<DeliveryRequest> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;
  RequestStatus? _selectedFilter;

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
      final requests = await _apiService.getDeliveryRequests();
      
      if (mounted) {
        setState(() {
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

  List<DeliveryRequest> _getFilteredRequests() {
    if (_selectedFilter == null) return _requests;
    return _requests.where((request) => request.status == _selectedFilter).toList();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF1A73E8),
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildContent() {
    final filteredRequests = _getFilteredRequests();
    
    return Column(
      children: [
        if (_selectedFilter != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Chip(
              label: Text('Filtre: ${_getStatusText(_selectedFilter!)}'),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  _selectedFilter = null;
                });
              },
              backgroundColor: _getStatusColor(_selectedFilter!).withOpacity(0.1),
              labelStyle: TextStyle(color: _getStatusColor(_selectedFilter!)),
            ),
          ),
        
        Expanded(
          child: filteredRequests.isEmpty
              ? const Center(child: Text('Aucune demande trouvée'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0), // For FAB space
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    return RequestListItem(request: filteredRequests[index]);
                  },
                ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tous'),
              leading: Radio<RequestStatus?>(
                value: null,
                groupValue: _selectedFilter,
                onChanged: (value) => _applyFilter(value),
              ),
              onTap: () => _applyFilter(null),
            ),
            ...RequestStatus.values.map(
              (status) => ListTile(
                title: Text(_getStatusText(status)),
                leading: Radio<RequestStatus?>(
                  value: status,
                  groupValue: _selectedFilter,
                  onChanged: (value) => _applyFilter(value),
                ),
                onTap: () => _applyFilter(status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilter(RequestStatus? status) {
    setState(() {
      _selectedFilter = status;
    });
    Navigator.of(context).pop();
  }
  
  String _getStatusText(RequestStatus status) {
    switch (status) {
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
  
  Color _getStatusColor(RequestStatus status) {
    switch (status) {
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