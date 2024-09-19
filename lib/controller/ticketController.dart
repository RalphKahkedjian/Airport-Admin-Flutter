import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:airportadminflutter/model/Ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketController extends GetxController {
  var tickets = <Ticket>[].obs; // Observable list of tickets

  TextEditingController departure = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController flightNumberController = TextEditingController();
  TextEditingController seatNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();

 void createTicket() async {
  try {
    double price = double.tryParse(priceController.text) ?? 0.0;

    DateTime now = DateTime.now();
    DateTime departureTime = _parseTime(departureTimeController.text, now);
    DateTime arrivalTime = _parseTime(arrivalTimeController.text, now);

    Ticket ticket = Ticket(
      departure: departure.text,
      destination: destination.text,
      flightNumber: flightNumberController.text,
      seatNumber: seatNumberController.text,
      price: price,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );

    String requestBody = ticket.toJson();

    var response = await DioClient().GetInstance().post('/ticket', data: requestBody);
    print("Response: ${response.data}");

    if (response.statusCode == 200 && response.data['success'] == true) {
      String ticketId = response.data['ticket']['id'].toString(); 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ticket_id', ticketId);
      print("Ticket ID saved: $ticketId"); 

      showsuccessdialog(Get.context!, "Success", "Your ticket has been created successfully", () {
        Get.offNamed('/home');
      });
    } else {
      print("Failed to create ticket: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while creating ticket: $e");
    showsuccessdialog(Get.context!, "Error", "An error occurred while creating the ticket. Please try again.", () {
      Get.back();
    });
  }
}


  DateTime _parseTime(String timeString, DateTime date) {
    try {
      final DateFormat formatter = DateFormat.jm();
      DateTime time = formatter.parse(timeString);
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      print("Error parsing time: $e");
      throw FormatException("Invalid time format");
    }
  }

void deleteTickets() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ticketId = prefs.getString('ticket_id');

    if (ticketId != null) {
      var response = await DioClient().GetInstance().delete('/ticket/$ticketId');
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        showsuccessdialog(Get.context!, "Ticket Deleted Successfully", "", () {
        });
      } else {
        print("Failed to delete ticket: ${response.statusCode}");
      }
    } else {
      print("No ticket ID found in SharedPreferences.");
    }
  } catch (e) {
    print('Error deleting ticket: $e');
  }
}




}
