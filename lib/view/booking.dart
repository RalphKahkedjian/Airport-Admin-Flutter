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
  static final TicketController controller = Get.put(TicketController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets Available", style: TextStyle(color: Colors.blueGrey[900]!)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: tickets.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text("No Tickets Found", style: TextStyle(color: Colors.blueGrey[900]!, fontSize: 18)),
              )
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  var ticket = tickets[index];

                  // Transforming the datetime to hh:mm format
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
                          SizedBox(height: 8),
                          Text("Flight: ${ticket['flight_number']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 4),
                          Text("Seat: ${ticket['seat_number']}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 16),
                          Text(
                            "Departure: $formattedDepartureTime",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Arrival Time: $formattedArrivalTime",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Spots: ${ticket['spots']}",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
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
                                          controller.deleteTickets(ticketID, () {
                                            showsuccessdialog(Get.context!, "Ticket Deleted Successfully", "", () {
                                              print("Ticket ID $ticketID has been deleted");
                                            });
                                            getTickets();
                                          }, (errorMessage) {
                                            showsuccessdialog(Get.context!, "Error", errorMessage, () {});
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[900],
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Delete", style: TextStyle(color: Colors.white)),
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
