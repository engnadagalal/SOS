import 'package:flutter/material.dart';
import 'package:sos_app/styles/colors.dart';
import 'package:sos_app/tabs/doctor_HomeTab.dart';
import 'package:sos_app/tabs/icon_tap_Doctor.dart';
import 'package:sos_app/tabs/patient_Profile.dart';
import 'package:sos_app/tabs/location_Page.dart'; // Import LocationPage

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

List<Map> navigationBarItems = [
  {'icon': Icons.local_hospital, 'index': 0},
  {'icon': Icons.calendar_today, 'index': 1},
  {'icon': Icons.person, 'index': 2}, // Added profile icon
  {'icon': Icons.location_on, 'index': 3}, // Added location icon
];

class _DoctorHomeState extends State<DoctorHome> {
  int _selectedIndex = 0;

  void goToIconTabDoctor() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void goToProfile() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void goToLocationPage() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeTab(
        onPressedIconTabDoctor: goToIconTabDoctor,
      ),
      IconTabDoctor(),
      ProfilePage(), // New profile page added here
      DoctorBotPage(), // Add the new LocationPage here
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(MyColors.primary),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        selectedItemColor: Color(MyColors.primary),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          for (var navigationBarItem in navigationBarItems)
            BottomNavigationBarItem(
              icon: Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border(
                    top: _selectedIndex == navigationBarItem['index']
                        ? BorderSide(color: Color(MyColors.bg01), width: 5)
                        : BorderSide.none,
                  ),
                ),
                child: Icon(
                  navigationBarItem['icon'],
                  color: _selectedIndex == navigationBarItem['index']
                      ? Color(MyColors.bg01)
                      : Color(MyColors.bg02),
                ),
              ),
              label: '',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientProfile()),
            );
          } else if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorBotPage()),
            );
          } else {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(MyColors.primary),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Information Here'),
            // Add your profile information widgets here
          ],
        ),
      ),
    );
  }
}
