import 'package:airportadminflutter/controller/ticketController.dart';
import 'package:get/get.dart';

class Ticketbinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>TicketController());
  }
}