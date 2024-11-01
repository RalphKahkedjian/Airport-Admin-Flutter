import 'package:airportadminflutter/view/admins.dart';
import 'package:airportadminflutter/view/booking.dart';
import 'package:airportadminflutter/view/login.dart';
import 'package:airportadminflutter/view/profile.dart';
import 'package:airportadminflutter/view/registration.dart';
import 'package:airportadminflutter/view/tickets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String startRoute = prefs.getString('token') != null ? '/home' : '/login'; 
  runApp(MyApp(startRoute: startRoute));
}

class MyApp extends StatelessWidget {
  final String startRoute;
  const MyApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airport Admin',
      initialRoute: startRoute,
      routes: {
        '/booking': (context) => Booking(),
        '/register': (context) => Registration(),
        '/login': (context) => Login(),
        '/home': (context) => const DefaultLayout(),
      },
    );
  }
}

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({super.key});

  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  int _selectedIndex = 0;
 
  final List<Widget> _pages = [
    Booking(),
    Ticket(),
    Admins(),
    Profile(),
  ];

  final List<String> _titles = [
    'Bookings',
    'Tickets',
    'Admins',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_airport_sharp),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Admins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueGrey[900],
        unselectedItemColor: Colors.grey[500],
      ),
    );
  }
}
