import 'package:airportadminflutter/controller/ticketController.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:flutter/material.dart';
import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List<dynamic> tickets = [];
  List<dynamic> bookedTickets = [];
  bool showBookedTickets = false; 
  static final TicketController ticketController = Get.put(TicketController());
  @override
  void initState() {
    super.initState();
    getTickets();
  }

  void getTickets() async {
    try {
      var response = await DioClient().GetInstance().get('/ticket');
      if (response.statusCode == 200) {
        var ticketData = response.data['data'];
        if (ticketData is List) {
          setState(() {
            tickets = ticketData;
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

  void getBookedTickets() async {
    try {
      var response = await DioClient().GetInstance().get('/book');
      if (response.statusCode == 200) {
        var bookedData = response.data['data'];
        if (bookedData is List) {
          setState(() {
            bookedTickets = bookedData;
            showBookedTickets = true;
          });
        } else {
          print("Expected booked data to be a list but got: ${bookedData.runtimeType}");
        }
      } else {
        print("Failed to load booked tickets: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching booked tickets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showBookedTickets = false; 
                  });
                  getTickets(); 
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
        child: Text("Available Tickets", style: TextStyle(color: Colors.white)),
      ),
      SizedBox(width: 10),
      TextButton(
        onPressed: () {
          getBookedTickets(); 
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text("Booked Tickets", style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
],
      ),
      body: Center(
        child: showBookedTickets
            ? bookedTickets.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text("No Booked Tickets Found", style: TextStyle(color: Colors.blueGrey[900]!, fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: bookedTickets.length,
                    itemBuilder: (context, index) {
                      var bookedTicket = bookedTickets[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.blueGrey[900]!, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.airplanemode_active, size: 40, color: Colors.blueGrey[900]!),
                              SizedBox(height: 10),
                              Text(
                                "Booked Ticket ID: ${bookedTicket['id']}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900]!,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Divider(color: Colors.black),
                              SizedBox(height: 8),
                              Text("User ID: ${bookedTicket['user_id']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 8),
                              Text("Ticket ID: ${bookedTicket['ticket_id']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 8),
                              Text("Quantity: ${bookedTicket['quantity']}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                              SizedBox(height: 8),
                              Text("Status: ${bookedTicket['status']}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                              SizedBox(height: 8),
                              Text("Created At: ${bookedTicket['created_at']}", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      );
                    },
                  )
            : tickets.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text("No Tickets Found", style: TextStyle(color: Colors.blueGrey[900]!, fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      var ticket = tickets[index];
                      DateTime arrivalDateTime = DateTime.parse(ticket['arrival_time']);
                      String formattedArrivalTime = DateFormat('HH:mm').format(arrivalDateTime);

                      DateTime departureDateTime = DateTime.parse(ticket['departure_time']);
                      String formattedDepartureTime = DateFormat('HH:mm').format(departureDateTime);

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.blueGrey[900]!, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.airplanemode_active, size: 40, color: Colors.blueGrey[900]!),
                              SizedBox(height: 10),
                              Text(
                                "${ticket['departure']} to ${ticket['destination']}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900]!,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Divider(color: Colors.black),
                              SizedBox(height: 13),
                              Text("Flight: ${ticket['flight_number']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 8),
                              Text("Seat: ${ticket['seat_number']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              SizedBox(height: 8),
                              Text(
                                "Departure: $formattedDepartureTime",
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Arrival Time: $formattedArrivalTime",
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Spots: ${ticket['spots']}",
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  int ticketID = ticket['id'];
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Confirm Delete"),
                                        content: Text("Are you sure you want to delete this ticket?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                ticketController.deleteTickets(ticketID, () {
                                                  showsuccessdialog(Get.context!, "Ticket Deleted", "Ticket has been deleted successfully", null);
                                                  getTickets();
                                                }, (error) {
                                                  showsuccessdialog(Get.context!, "Error", "Failed to delete the ticket: $error", null);
                                                });
                                              },
                                            ),

                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Delete Ticket"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
