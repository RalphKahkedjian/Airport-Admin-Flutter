import 'package:airportadminflutter/binding/adminsBinding.dart';
import 'package:airportadminflutter/binding/homeBinding.dart';
import 'package:airportadminflutter/binding/loginBinding.dart';
import 'package:airportadminflutter/binding/registrationBinding.dart';
import 'package:airportadminflutter/routes/AppRoute.dart';
import 'package:airportadminflutter/view/admins.dart';
import 'package:airportadminflutter/view/home.dart';
import 'package:airportadminflutter/view/login.dart';
import 'package:airportadminflutter/view/profile.dart';
import 'package:airportadminflutter/view/registration.dart';
import 'package:airportadminflutter/view/tickets.dart';
import 'package:get/get.dart';

class Apppage {
  static final List <GetPage> pages = [
    GetPage(name: Approute.home, page: ()=>Home(), binding: Homebinding()),
    GetPage(name: Approute.login, page: ()=>Login(), binding: Loginbinding()),
    GetPage(name: Approute.register, page: ()=>Registration(), binding: Registrationbinding()),
    GetPage(name: Approute.admins, page: ()=>Admins(), binding: Adminsbinding()),
    GetPage(name: Approute.profile, page: ()=>Profile()),
    GetPage(name: Approute.ticket, page: ()=>Ticket())
  ];
}