import 'package:flutter/material.dart';
import 'package:latesttutorapp/models/user.dart';
import 'package:latesttutorapp/subjectscreen.dart';
import 'package:latesttutorapp/tutorsscreen.dart';

//void main() => runApp(const MyApp());

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late double screenHeight, screenWidth, resWidth;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _tabChildren;

  @override
  void initState() {
    super.initState();
    _tabChildren = <Widget>[
      const SubjectScreen(
      ),
      const TutorScreen(
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tutor',textAlign: TextAlign.center),
        backgroundColor: Colors.cyan,
      ),
      body: /*Center(child: _tabChildren.elementAt(_selectedIndex),),*/
      IndexedStack(
        index: _selectedIndex,
        children: _tabChildren,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan,
        selectedItemColor: Colors.amber[800],
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
