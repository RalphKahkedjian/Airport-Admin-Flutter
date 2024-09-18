import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:airportadminflutter/model/Ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketController extends GetxController {
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

      // Parse the time with AM/PM
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
      
      if (response.statusCode == 200) {
        print("Ticket created successfully: ${response.data}");
        showsuccessdialog(Get.context!, "Success", "Your ticket has been created successfully", () {
          Get.offNamed('/home');
        });
      } else {
        print("Failed to create ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while creating ticket: $e");
      // Optionally, show an error dialog or message
      showsuccessdialog(Get.context!, "Error", "An error occurred while creating the ticket. Please try again.", () {
        Get.back();
      });
    }
  }

  DateTime _parseTime(String timeString, DateTime date) {
    try {
      // Parse the time string like "9:01 PM"
      final DateFormat formatter = DateFormat.jm(); // For parsing "9:01 PM"
      // Parse the time using the formatter
      DateTime time = formatter.parse(timeString);
      
      // Combine the parsed time with the provided date
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      print("Error parsing time: $e");
      // Handle parsing error, you might want to throw an exception or return a default value
      throw FormatException("Invalid time format");
    }
  }
}
