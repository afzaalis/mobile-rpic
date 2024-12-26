import 'package:flutter/material.dart';
import 'package:rpic_mobile_beta/local_notifications.dart';
import 'orderPage.dart';

class BetaPage extends StatefulWidget {
  final String pcType; 

  const BetaPage({super.key, required this.pcType}); 

  @override
  _BetaPageState createState() => _BetaPageState();
}

class _BetaPageState extends State<BetaPage> {
  List<String> selectedPCs = [];

  // Fungsi untuk mengubah status pemilihan PC
  void toggleSelection(String pc) {
    setState(() {
      if (selectedPCs.contains(pc)) {
        selectedPCs.remove(pc); 
      } else {
        if (selectedPCs.length < 3) {
          selectedPCs.add(pc); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You can only select a maximum of 3 PCs.")),
          );
        }
      }
    });
  }

  // Fungsi untuk menghitung total harga berdasarkan jumlah PC yang dipilih
  double calculateTotalPrice(List<String> selectedPCs) {
    return selectedPCs.length * 20000; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF05051E),
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.pcType.toUpperCase(), 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Image.asset(
              "images/imgPagePC/selectionNote.png",
              height: 30,
            ),
          ],
        ),
        backgroundColor: Color(0xFF2C2D59),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            spacing: 20.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            children: [
              // Menampilkan 56 PC untuk tipe Beta
              for (int i = 1; i <= 56; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(75, 50),
                      backgroundColor: selectedPCs.contains("Beta-$i") ? Color(0xFF640EF1) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      toggleSelection("Beta-$i"); // Menggunakan ID Beta-1, Beta-2, dst
                      LocalNotifications.showSimpleNotification(
                        title: "PC Beta-$i ${selectedPCs.contains("Beta-$i") ? "Selected" : "Unselected"}",
                        body: "PC Beta-$i has been ${selectedPCs.contains("Beta-$i") ? "added" : "removed"} from the selection.",
                        payload: "PC Beta-$i ${selectedPCs.contains("Beta-$i") ? "selected" : "unselected"}",
                      );
                    },
                    child: Text(
                      "Beta-$i", // Menampilkan ID PC yang dipilih
                      style: TextStyle(color: selectedPCs.contains("Beta-$i") ? Colors.white : Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF2C2D59),
        padding: EdgeInsets.all(10),
        height: 180,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Selected PCs",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedPCs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Chip(
                        label: Text(
                          selectedPCs[index], // Menampilkan ID PC yang dipilih
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFF640EF1),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  if (selectedPCs.isNotEmpty) {
                    double totalPrice = calculateTotalPrice(selectedPCs); // Menghitung total harga
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(
                          selectedPCs: selectedPCs,
                          totalPrice: totalPrice,  // Mengirim total harga
                          pcType: widget.pcType,   // Mengirim tipe PC
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select at least one PC.")),
                    );
                  }
                },
                child: Text("Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF640EF1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
