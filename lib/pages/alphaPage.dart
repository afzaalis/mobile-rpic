import 'package:flutter/material.dart';
import 'package:rpic_mobile_beta/local_notifications.dart'; 
import 'orderPage.dart'; 

class Alphapage extends StatefulWidget {
  final String pcType;  
  const Alphapage({super.key, required this.pcType});  

  @override
  _AlphapageState createState() => _AlphapageState();
}

class _AlphapageState extends State<Alphapage> {
  List<String> selectedPCs = [];  

  // Fungsi untuk mengubah status pemilihan PC
  void toggleSelection(String pc) {
    setState(() {
      if (selectedPCs.contains(pc)) {
        selectedPCs.remove(pc);  
      } else if (selectedPCs.length < 3) {
        selectedPCs.add(pc);  
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can only select up to 3 PCs.")),
        );
      }
    });
  }

  // Fungsi untuk menghitung total harga berdasarkan jumlah PC yang dipilih
  double calculateTotalPrice(List<String> selectedPCs) {
    double totalPrice = 0;
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

    // Menghitung total harga berdasarkan jumlah PC yang dipilih
    totalPrice = selectedPCs.length * pricePerPC;
    return totalPrice;
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
              "PC ${widget.pcType}",  
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Image.asset("images/imgPagePC/selectionNote.png", height: 30),  // Gambar tambahan
          ],
        ),
        backgroundColor: Color(0xFF2C2D59),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            children: [
              // Menampilkan 16 PC untuk tipe Alpha
              for (int i = 1; i <= 16; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(75, 50),
                      backgroundColor: selectedPCs.contains("Alpha-$i") ? Color(0xFF640EF1) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {
                      toggleSelection("Alpha-$i");  // Menggunakan ID Alpha-1, Alpha-2, dst
                      LocalNotifications.showSimpleNotification(
                        title: "PC Alpha-$i ${selectedPCs.contains("Alpha-$i") ? "Selected" : "Unselected"}",
                        body: "PC Alpha-$i has been ${selectedPCs.contains("Alpha-$i") ? "added" : "removed"} from the selection.",
                        payload: "PC Alpha-$i ${selectedPCs.contains("Alpha-$i") ? "selected" : "unselected"}",
                      );
                    },
                    child: Text(
                      "Alpha-$i",  // Menampilkan ID PC yang dipilih
                      style: TextStyle(color: selectedPCs.contains("Alpha-$i") ? Colors.white : Colors.black),
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
                "Selected PCs",  // Judul untuk menampilkan PC yang dipilih
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                          selectedPCs[index],  // Menampilkan ID PC yang dipilih
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
                  if (selectedPCs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select at least one PC")),
                    );
                    return;
                  }
                  double totalPrice = calculateTotalPrice(selectedPCs);  // Menghitung total harga
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(
                        selectedPCs: selectedPCs,
                        totalPrice: totalPrice,  
                        pcType: widget.pcType,  
                      ),
                    ),
                  );
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
