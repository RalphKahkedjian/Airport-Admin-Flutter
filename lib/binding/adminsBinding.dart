import 'package:airportadminflutter/controller/adminsController.dart';
import 'package:get/get.dart';

class Adminsbinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>Adminscontroller());
  }
}