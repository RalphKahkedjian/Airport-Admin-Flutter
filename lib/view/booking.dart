import 'package:airportadminflutter/controller/ticketController.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:flutter/material.dart';
import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:get/get.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<dynamic> tickets = []; // Declare the tickets list to store fetched tickets
    static final TicketController controller = Get.put(TicketController());
    

  @override
  void initState() {
    super.initState();
    getTickets(); // Call the getTickets method on widget initialization
  }

  void getTickets() async {
    try {
      var response = await DioClient().GetInstance().get('/ticket');

      if (response.statusCode == 200) {
        var ticketData = response.data['data'];

        if (ticketData is List) {
          setState(() {
            tickets = ticketData; // Store the list of tickets
          });
        } else {
          print("Expected ticket data to be a list but got: ${ticketData.runtimeType}");
        }
      } else {
        print("Failed to load tickets: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching tickets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(child: Text("Tickets Available"),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: tickets.isEmpty
            ? 
              Text("No Tickets Found")
            
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(color: Colors.blueGrey[900]!, width: 7.0),
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Departure: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['departure']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Destination: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['destination']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Price: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['price']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Seat Number: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['seat_number']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Arrival Time: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['arrival_time']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Departure Time: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['departure_time']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Status: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['status']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        SizedBox(height: 15,),
                      
                                      
                    ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
