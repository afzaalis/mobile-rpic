import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHistoryPage extends StatefulWidget {
  @override
  _AdminHistoryPageState createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  List<dynamic> completedBookings = [];
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchCompletedBookings();
  }

  Future<void> _fetchCompletedBookings() async {
    final String apiUrl = "http://10.0.2.2:3000/api/bookings";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            // Filter hanya booking dengan status "completed"
            completedBookings = data.where((booking) => booking['status'] == "completed").toList();
          });
        } else {
          setState(() {
            error = "Unexpected response format";
          });
        }
      } else {
        setState(() {
          error = "Failed to fetch data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        error = "Failed to fetch bookings. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05051E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2D59),
        title: const Text(
          "Admin Dashboard - Completed Bookings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (completedBookings.isEmpty && error == null)
              const Center(child: CircularProgressIndicator()),
            if (completedBookings.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: completedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = completedBookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reservation #${booking['id']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("User ID: ${booking['user_id']}"),
                            Text("Total Price: Rp.${booking['total_price']}"),
                            Text("Status: ${booking['status']}"),
                            Text("Created At: ${booking['created_at']}"),
                            Text("Updated At: ${booking['updated_at']}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
