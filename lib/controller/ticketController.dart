import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:airportadminflutter/model/Ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketController extends GetxController {
  var tickets = <Ticket>[].obs;

  TextEditingController departure = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController flightNumberController = TextEditingController();
  TextEditingController seatNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController spots = TextEditingController();

 void createTicket() async {
  try {
    double price = double.tryParse(priceController.text) ?? 0.0;

    int spotsValue = int.tryParse(spots.text) ?? 0;
    if (spotsValue < 50 || spotsValue > 200) {
      throw Exception("Spots must be between 50 and 200.");
    }

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
      spots: spotsValue.toString(),
    );

    String requestBody = ticket.toJson();

    var response = await DioClient().GetInstance().post('/ticket', data: requestBody);
    print("Response: ${response.data}");

    if (response.statusCode == 200 && response.data['success'] == true) {
      String ticketId = response.data['ticket']['id'].toString(); 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ticket_id', ticketId);
      print("Ticket ID saved: $ticketId"); 
      clearTextFields();
      showsuccessdialog(Get.context!, "Success", "Your ticket has been created successfully", () {
        print("Ticket ID of ${ticketId} has been created");
      });
    } else {
      print("Failed to create ticket: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while creating ticket: $e");
    showsuccessdialog(Get.context!, "Error", e.toString(), () {
      Get.back();
    });
  }
}

void clearTextFields() {
  departure.clear();
  destination.clear();
  flightNumberController.clear();
  seatNumberController.clear();
  priceController.clear();
  departureTimeController.clear();
  arrivalTimeController.clear();
  spots.clear();
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

void deleteTickets(int ticketID, Function onSuccess, Function onError) async {
  try {
    var response = await DioClient().GetInstance().delete('/ticket/$ticketID');
    if (response.statusCode == 200) {
      onSuccess();
    } else {
      print("Error deleting ticket: ${response.data}");
      onError("Failed to delete ticket.");
    }
  } catch (e) {
    print("Error: $e");
    onError("An unexpected error occurred.");
  }
}
}
