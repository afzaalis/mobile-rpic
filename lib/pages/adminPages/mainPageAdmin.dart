import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<dynamic> bookings = [];
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchBookings(); 
  }

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:3000/api/bookings"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter bookings yang tidak berstatus "completed"
        setState(() {
          bookings = data.where((booking) => booking["status"] != "completed").toList();
        });
      } else {
        setState(() {
          error = "Failed to fetch bookings. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        error = "An error occurred while fetching bookings. Please try again.";
      });
    }
  }

  Future<void> updateBookingToCompleted(int id) async {
    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:3000/api/bookings/$id/completed"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"status": "completed"}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking marked as completed")),
        );
        fetchBookings(); // Refresh bookings list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update booking status")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      final response = await http.delete(Uri.parse("http://10.0.2.2:3000/api/bookings/$id"));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking deleted successfully")),
        );
        fetchBookings(); // Refresh bookings list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete booking")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF05051E),
    appBar: AppBar(
      title: const Text(
        'View Booking',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xFF2C2D59),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: bookings.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(bottom: 80.0), 
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reservation #${booking['id']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8.0),
                        Text("User ID: ${booking['user_id']}"),
                        Text("Total Price: Rp.${booking['total_price']}"),
                        Text("Status: ${booking['status']}"),
                        Text("Created At: ${booking['created_at']}"),
                        Text("Updated At: ${booking['updated_at']}"),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  updateBookingToCompleted(booking['id']),
                              child: Text("Complete"),
                            ),
                            SizedBox(width: 8.0),
                            TextButton(
                              onPressed: () => deleteBooking(booking['id']),
                              child: Text("Delete"),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : error.isNotEmpty
              ? Center(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    ),
  );
}
}
