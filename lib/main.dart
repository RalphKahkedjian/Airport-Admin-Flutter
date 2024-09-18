import 'package:airportadminflutter/view/admins.dart';
import 'package:airportadminflutter/view/home.dart'; // Ensure this file exists
import 'package:airportadminflutter/view/login.dart';
import 'package:airportadminflutter/view/profile.dart';
import 'package:airportadminflutter/view/registration.dart';
import 'package:airportadminflutter/view/tickets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print('Token: $token'); // Debug statement
  runApp(MyApp(startRoute: token == null ? '/register' : '/home'));
}

class MyApp extends StatelessWidget {
  final String startRoute;
  const MyApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Default Layout Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: startRoute,
      routes: {
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
  String _name = "";

  @override
  void initState() {
    super.initState();
    _loadName(); // Load name from SharedPreferences
  }

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "User"; 
    });
  }

  final List<Widget> _pages = [
    Home(),
    Ticket(),
    Admins(),
    Profile(),
  ];

  final List<String> _titles = [
    'Home',
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
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange[900],
              ),
              child: Text(
                'Welcome back, $_name', // Display the name
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tickets'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Admins'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.grey[500],
      ),
    );
  }
}
