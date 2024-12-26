import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _history = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); 
  }

  Future<void> _getUserId() async {
    final userId = await _secureStorage.read(key: 'userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      _fetchHistory(); 
    }
  }

  Future<void> _fetchHistory() async {
    if (_userId == null) return;
      final url = Uri.parse('http://10.0.2.2:3000/api/bookings/history/$_userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _history = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch history');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching history: $e');
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.yellow;
      case "cancelled":
        return Colors.red;
      case "confirmed":
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  void _showReservationDetails(BuildContext context, dynamic item) {
  final selectedPCs = item['selected_pcs'] as List<dynamic>?;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reservation Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Reservation #${item['id']}'),
          Text('Status: ${item['status']}'),
          Text('Date: ${item['created_at'] ?? 'Unknown'}'),
          if (selectedPCs != null && selectedPCs.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              "Selected PCs:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...selectedPCs.map((pc) {
              return Text(
                "- PC ID: ${pc['pc_id']}, Hours: ${pc['hours']}, Price: ${pc['price']}",
              );
            }).toList(),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05051E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Reservation History",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0XFF15162F),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
  child: ListView.builder(
    itemCount: _history.length,
    itemBuilder: (context, index) {
      final item = _history[index];
      final status = item['status'];
      final statusColor = _getStatusColor(status);
      final selectedPCs = item['selected_pcs'] as List<dynamic>?;

      return Card(
        color: const Color(0xFF1F1F2F),
        child: ListTile(
          title: Text(
            "Reservation #${item['id']}",
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date: ${item['created_at'] ?? 'Unknown'}",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (selectedPCs != null && selectedPCs.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected PCs:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...selectedPCs.map((pc) {
                      return Text(
                        "- PC ID: ${pc['pc_id']}, Hours: ${pc['hours']}, Price: ${pc['price']}",
                        style: const TextStyle(color: Colors.white70),
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward, color: Colors.white),
          onTap: () {
            _showReservationDetails(context, item);
          },
        ),
      );
    },
  ),
),

                ],
              ),
            ),
          ),
        );
      }
    }
