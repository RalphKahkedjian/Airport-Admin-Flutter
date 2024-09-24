import 'package:airportadminflutter/controller/ticketController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Ticket extends StatelessWidget {
  final TicketController controller = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Create Ticket'),),
        automaticallyImplyLeading: false,
        centerTitle: false,
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(35),
        child: Column(
          children: [
              TextField(
              controller: controller.departure,
              decoration: InputDecoration(labelText: 'Departure'),
            ),
            SizedBox(height: 15,),
              TextField(
              controller: controller.destination,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.flightNumberController,
              decoration: InputDecoration(labelText: 'Flight Number'),
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.seatNumberController,
              decoration: InputDecoration(labelText: 'Seat Number'),
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.departureTimeController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Departure Time (HH:mm)'),
              onTap: () => _selectTime(controller.departureTimeController),
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.arrivalTimeController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Arrival Time (HH:mm)'),
              onTap: () => _selectTime(controller.arrivalTimeController),
            ),
                SizedBox(height: 15,),
            TextField(
              controller: controller.spots,
              decoration: InputDecoration(labelText: 'Spots'),
              keyboardType: TextInputType.number,
            ),
                SizedBox(height: 25,),
            ElevatedButton(
              onPressed: () {
                controller.createTicket();
               
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900]),  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),),
              child: Text('Create Ticket', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
        ),
        )
      ),
    );
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(Get.context!);
      controller.text = formattedTime;
    }
  }
}
