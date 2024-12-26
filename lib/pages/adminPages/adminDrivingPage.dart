import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDrivingSimulatorPage extends StatefulWidget {
  const AdminDrivingSimulatorPage({Key? key}) : super(key: key);

  @override
  _AdminDrivingSimulatorPageState createState() => _AdminDrivingSimulatorPageState();
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onDelete;

  const BookingCard({required this.booking, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(
          "Booking ID: ${booking['id']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User ID: ${booking['user_id']}"),
            Text("Total Price: \$${booking['total_price']}"),
            Text("Status: ${booking['status']}"),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete Booking'),
                  content: Text('Are you sure you want to delete this booking?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup popup sebelum proses delete
                        onDelete();
                      },
                      child: Text("Yes", style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("No"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class _AdminDrivingSimulatorPageState extends State<AdminDrivingSimulatorPage> {
List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  final String apiUrl = 'http://10.0.2.2:3000/api/bookings';

Future<void> fetchConfirmedBookings() async {
  final url = Uri.parse('http://10.0.2.2:3000/api/bookings/confirmed');
  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      setState(() {
        bookings = data; 
        isLoading = false; 
      });
    } else {
      print('Failed to fetch bookings: ${response.statusCode}');
      setState(() {
        isLoading = false; 
      });
    }
  } catch (e) {
    print('Error fetching bookings: $e');
    setState(() {
      isLoading = false; 
    });
  }
}


  Future<void> deleteBooking(String bookingId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.delete(Uri.parse('$apiUrl/$bookingId'));
      Navigator.of(context).pop(); 
      if (response.statusCode == 200) {
        setState(() {
          bookings.removeWhere((booking) => booking['id'] == bookingId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete booking")),
        );
      }
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting booking: $error")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConfirmedBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Alpha PC Management"),
        backgroundColor: Color(0xFF2C2D59),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? Center(
                  child: Text(
                    "No confirmed bookings found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: BookingCard(
                        booking: booking,
                        onDelete: () =>
                            deleteBooking(booking['id'].toString()),
                      ),
                    );
                  },
                ),
    );
  }
}