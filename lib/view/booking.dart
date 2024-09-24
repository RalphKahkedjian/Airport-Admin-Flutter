import 'package:airportadminflutter/controller/ticketController.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:flutter/material.dart';
import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: Center(child: Text("Tickets Available")),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: tickets.isEmpty
            ? Text("No Tickets Found")
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
                            Text("ID: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['id']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Departure: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['departure']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Destination: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['destination']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Price: €", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['price']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Seat Number: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['seat_number']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Arrival Time: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['arrival_time']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Departure Time: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['departure_time']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                               Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Spots: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['spots']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                           Divider(color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Status: ", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                            Text("${tickets[index]['status']}", style: TextStyle(color: Colors.blueGrey[900])),
                          ],
                        ),
                        Divider(color: Colors.black,),
                        SizedBox(height: 15),
                        Center(
                          child: ElevatedButton(
                          onPressed: () async {
                            int ticketID = tickets[index]['id'];

                            if (ticketID != null) {
                               showsuccessdialog(Get.context!, "Ticket Deleted Successfully", "", () {
                                print("Ticket ID $ticketID has been deleted");
                                controller.deleteTickets(ticketID);
                              });
                              getTickets();
                            } else {
                              showsuccessdialog(Get.context!, "Error", "Ticket ID not found.", () {});
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900]),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                          child: Text("Delete", style: TextStyle(color: Colors.white)),
                        ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
