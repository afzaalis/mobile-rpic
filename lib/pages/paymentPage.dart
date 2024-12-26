import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rpic_mobile_beta/components/bottom_nav_bar.dart';
import 'package:tab_container/tab_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentPage extends StatefulWidget {
  final String totalPrice;

  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Timer _timer;
  int _remainingTime = 300; 
  double userBalance = 50000.0; 
  String selectedPaymentMethod = ''; 
  int? bookingId; 

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getBookingId();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment time expired.')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  // Fungsi untuk mendapatkan bookingId berdasarkan userId dari secure storage
 Future<void> _getBookingId() async {
  String? userId = await _secureStorage.read(key: 'userId');
  if (userId != null) {
    final url = 'http://10.0.2.2:3000/api/bookings';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> bookings = json.decode(response.body);
      
      final pendingBookings = bookings.where(
        (booking) => booking['user_id'] == int.parse(userId) && booking['status'] == 'pending',
      ).toList();

      if (pendingBookings.isNotEmpty) {
        final latestBooking = pendingBookings.first;

        setState(() {
          bookingId = latestBooking['id'];
        });
      } else {
        print('No pending bookings found');
      }
    } else {
      print('Failed to fetch bookings');
    }
  }
}


  // Fungsi untuk memperbarui status booking setelah pembayaran
  Future<void> _updateBookingStatus(int bookingId, String status) async {
    final url = 'http://10.0.2.2:3000/api/bookings/$bookingId/payment';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'paymentStatus': status}),
    );

    if (response.statusCode == 200) {
      print('Booking status updated to confirmed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processed successfully. Booking confirmed.')),
      );
    } else {
      print('Failed to update booking status');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm booking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = double.tryParse(widget.totalPrice) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Payment Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment Confirmation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Total Amount: ${widget.totalPrice} IDR",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Your Balance: ${userBalance} IDR",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 20),

              // Timer Display
              Center(
                child: Text(
                  "Time Remaining: ${_formatTime(_remainingTime)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Tab Container for Payment Methods
              TabContainer(
                tabs: [
                  _buildPaymentTab('Dana'),
                  _buildPaymentTab('GoPay'),
                  _buildPaymentTab('m-Banking'),
                ],
                children: [
                  _buildPaymentMethodDetails('Dana'),
                  _buildPaymentMethodDetails('GoPay'),
                  _buildPaymentMethodDetails('m-Banking'),
                ],
              ),
              SizedBox(height: 20),

              // Pay Now button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (userBalance >= totalAmount) {
                      setState(() {
                        userBalance -= totalAmount; 
                      });

                      if (bookingId != null) {
                        // Memperbarui status booking
                        await _updateBookingStatus(bookingId!, 'confirmed');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Booking not found.')),
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment processed successfully.')),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Insufficient balance!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Pay Now", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat tab pembayaran dengan efek hover dan highlight ketika dipilih
  Widget _buildPaymentTab(String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method; 
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: selectedPaymentMethod == method
              ? Colors.green.withOpacity(0.7) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedPaymentMethod == method
                ? Colors.blueAccent
                : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          method,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selectedPaymentMethod == method
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDetails(String method) {
    String instructions;
    String virtualAccount;

    switch (method) {
      case 'Dana':
        instructions = "Transfer the total amount to the Dana account.";
        virtualAccount = "0812-3456-7890";
        break;
      case 'GoPay':
        instructions = "Transfer the total amount to the GoPay account.";
        virtualAccount = "0812-9876-5432";
        break;
      case 'm-Banking':
        instructions = "Transfer the total amount to the virtual account number.";
        virtualAccount = "869002135470";
        break;
      default:
        return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(instructions),
        SizedBox(height: 10),
        Text(
          "Virtual Account: $virtualAccount",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        Divider(height: 20, color: Colors.grey),
      ],
    );
  }
}
