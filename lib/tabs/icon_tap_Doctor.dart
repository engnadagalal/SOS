import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IconTabDoctor extends StatefulWidget {
  const IconTabDoctor({Key? key}) : super(key: key);

  @override
  _IconTabDoctorState createState() => _IconTabDoctorState();
}

class _IconTabDoctorState extends State<IconTabDoctor> {
  bool _isUpcomingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isUpcomingSelected = true;
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                      (_) => BorderSide(
                        color: _isUpcomingSelected
                            ? Colors.blue // Change to the desired color
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Text(
                    'Reservations',
                    style: TextStyle(
                      color: _isUpcomingSelected
                          ? Colors.blue // Change to the desired color
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DoctorCard(
                          doctorName: document['name'] ?? '',
                          doctorspecialty: document['specialty'] ?? '',
                          doctorData: document.data() as Map<String, dynamic>, // Cast to the expected type
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String doctorspecialty;
  final Map<String, dynamic> doctorData;

  const DoctorCard({
    Key? key,
    required this.doctorName,
    required this.doctorspecialty,
    required this.doctorData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Removed navigation to DoctorPage
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Replace with the desired color
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.blue, // Change to the desired color
                  size: 25,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Change to the desired color
                      ),
                    ),
                    Text(
                      doctorspecialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600], // Change to the desired color
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 120),
              ],
            ),
            SizedBox(height: 10),
            // Button row with spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showDoctorInfoDialog(context, doctorData);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (_) => Colors.blue, // Change to the desired gradient colors
                    ),
                  ),
                  child: Text(
                    'Info',
                    style: TextStyle(
                      color: Colors.white, // Change to the desired text color
                    ),
                  ),
                ),
                SizedBox(width: 10), // Adjust the spacing as needed
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showReservationDialog(context, doctorData);
                    },
                    child: Text('Reserve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReservationDialog(BuildContext context, Map<String, dynamic> doctorData) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reservation Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: '(Home or Clinic) & Address'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveReservationData(
                  nameController.text,
                  addressController.text,
                  phoneController.text,
                  emailController.text,
                  doctorData,
                );
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showDoctorInfoDialog(BuildContext context, Map<String, dynamic> doctorData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doctor Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfoField('Phone', doctorData['phone'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Email', doctorData['email'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Price', doctorData['Price'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Address', doctorData['Address'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Appointments', doctorData['Appointments'] ?? 'N/A'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _saveReservationData(String name, String address, String phone, String email, Map<String, dynamic> doctorData) async {
    // Save all data to Firestore
    await FirebaseFirestore.instance.collection('Patient.Resv.DR').add({
      'name': name,
      'title': address,
      'phone': phone,
      'email': email,
      // Add doctor data
      'doctor_name': doctorData['name'],
      'doctor_title': doctorData['title'],
      // Add more doctor fields as needed
    });
  }
}
