import 'package:airportadminflutter/controller/registrationController.dart';
import 'package:get/get.dart';

class Registrationbinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> RegistrationController());
  }
}