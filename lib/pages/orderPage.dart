import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'paymentPage.dart';

class OrderPage extends StatefulWidget {
  final List<String> selectedPCs;
  final double totalPrice;
  final String pcType; 

  const OrderPage({
    Key? key,
    required this.selectedPCs,
    required this.totalPrice,
    required this.pcType,  
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<String?> selectedDurations = [];
  List<String?> selectedStartTimes = [];
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(); // Instance dari FlutterSecureStorage

  @override
  void initState() {
    super.initState();
    selectedDurations = List<String?>.filled(widget.selectedPCs.length, null);
    selectedStartTimes = List<String?>.filled(widget.selectedPCs.length, null);
  }

  // Mengambil userId dari FlutterSecureStorage
  Future<String> getUserId() async {
    String? userId = await _secureStorage.read(key: 'userId');
    print('User ID from Secure Storage: $userId');
    return userId ?? '';
  }

 // Function to submit booking
Future<void> submitBooking(List<Map<String, dynamic>> bookings) async {
  const String apiUrl = 'http://10.0.2.2:3000/api/bookings';
  String userId = await getUserId();

  if (userId.isEmpty) {
    print("User ID not found");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User is not logged in')),
    );
    return;
  }

  try {
    // Prepare the booking data to send to the backend
   List<Map<String, dynamic>> bookingsWithPCId = bookings.map((booking) {
    String pcName = booking['pcName'];
    int pcId;

    String pcBaseName = pcName.split('-').first; 
    if (pcBaseName == 'Alpha') {
      pcId = 1;
    } else if (pcBaseName == 'Beta') {
      pcId = 2;
    } else if (pcBaseName == 'DS') {
      pcId = 3;
    } else {
      throw Exception("Invalid PC Name: $pcName");
    }


  String? duration = booking['duration'];
  if (duration == null) {
    throw Exception("Duration is missing for ${pcName}");
  }

  // Menghitung harga berdasarkan tipe PC dan durasi
  double price = calculatePrice(pcName, duration);

  print("Booking for $pcName: pc_id=$pcId, hours=$duration, price=$price"); // Log data booking

  return {
    'pc_id': pcId,
    'hours': duration,
    'price': price,
  };
}).toList();


    // Send POST request to backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'selectedPCs': bookingsWithPCId,
        'totalPrice': widget.totalPrice,
      }),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(totalPrice: widget.totalPrice.toString()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process the booking: ${response.body}')),
      );
    }
  } catch (e) {
    print("Error during API call: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred. Please try again.')),
    );
  }
}




  // Fungsi untuk menghitung harga berdasarkan durasi
  double calculatePrice(String pc, String? duration) {
    double pricePerPC = 0;

    switch (widget.pcType) {
      case 'Alpha':
        pricePerPC = 15000;  
        break;
      case 'Beta':
        pricePerPC = 12000;  
        break;
      case 'Driving Simulator':
        pricePerPC = 20000;  
        break;
      default:
        pricePerPC = 0;  
    }

    // Menentukan multiplier berdasarkan durasi yang dipilih
    int durationMultiplier = 0;
    switch (duration) {
      case '1 Hour':
        durationMultiplier = 1;
        break;
      case '2 Hours':
        durationMultiplier = 2;
        break;
      case '3 Hours':
        durationMultiplier = 3;
        break;
      default:
        durationMultiplier = 0;  
    }

    // Menghitung total harga berdasarkan tipe PC dan durasi
    double totalPrice = pricePerPC * durationMultiplier;
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Order Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected PCs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedPCs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.selectedPCs[index],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Select Usage Time:", style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: selectedDurations[index],
                          items: <String>['1 Hour', '2 Hours', '3 Hours'].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDurations[index] = newValue;
                            });
                          },
                          hint: Text('Select Duration'),
                        ),
                        SizedBox(height: 10),
                        Text("Select Start Time:", style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: selectedStartTimes[index],
                          items: <String>[
                            '08:00 AM',
                            '09:00 AM',
                            '10:00 AM',
                            '11:00 AM',
                            '12:00 PM',
                            '01:00 PM',
                            '02:00 PM',
                            '03:00 PM',
                          ].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedStartTimes[index] = newValue;
                            });
                          },
                          hint: Text('Select Start Time'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Price: ${calculatePrice(widget.selectedPCs[index], selectedDurations[index])} IDR",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bool isDataValid = true;
                for (int i = 0; i < widget.selectedPCs.length; i++) {
                  if (selectedDurations[i] == null || selectedStartTimes[i] == null) {
                    isDataValid = false;
                    break;
                  }
                }

                if (!isDataValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select duration and start time for all PCs')),
                  );
                  return;
                }

                // Membuat list booking yang akan dikirim ke server
                List<Map<String, dynamic>> bookings = [];
                for (int i = 0; i < widget.selectedPCs.length; i++) {
                  bookings.add({
                    'pcName': widget.selectedPCs[i],
                    'duration': selectedDurations[i],
                    'startTime': selectedStartTimes[i],
                  });
                }
                submitBooking(bookings);
              },
              child: Text("Confirm Order"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(totalPrice: widget.totalPrice.toString()),
                ),
              );
              },
              child: Text("Go to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
