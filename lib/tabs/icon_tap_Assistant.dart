import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssistantTap extends StatefulWidget {
  const AssistantTap({Key? key}) : super(key: key);

  @override
  _AssistantTapState createState() => _AssistantTapState();
}

class _AssistantTapState extends State<AssistantTap> {
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
              'Assistants',
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
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Text(
                    'Reservations',
                    style: TextStyle(
                      color: _isUpcomingSelected
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('assistants').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return AssistantCard(
                          assistantName: data['name'] ?? '',
                          assistantJob: data['job'] ?? '',
                          assistantData: data,
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

class AssistantCard extends StatelessWidget {
  final String assistantName;
  final String assistantJob;
  final Map<String, dynamic> assistantData;

  const AssistantCard({
    Key? key,
    required this.assistantName,
    required this.assistantJob,
    required this.assistantData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the tap action if needed
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
                  color: Colors.blue,
                  size: 25,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assistantName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      assistantJob,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAssistantInfoDialog(context, assistantData);
                  },
                  child: Text('Info'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showReservationDialog(context, assistantData);
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

  void _showReservationDialog(BuildContext context, Map<String, dynamic> assistantData) {
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
                decoration: InputDecoration(labelText: 'Address & Other'),
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
                  assistantData,
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

  void _showAssistantInfoDialog(BuildContext context, Map<String, dynamic> assistantData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assistant Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfoField('Name', assistantData['name'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Job', assistantData['job'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Price', assistantData['price'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Address', assistantData['address'] ?? 'N/A'),
              SizedBox(height: 10),
              _buildInfoField('Email', assistantData['email'] ?? 'N/A'),
              SizedBox(height: 10),
              // Add more fields here if needed
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

  void _saveReservationData(String name, String address, String phone, String email, Map<String, dynamic> assistantData) async {
    await FirebaseFirestore.instance.collection('Patient.Resv.MA').add({
      'name': name,
      'title': address,
      'phone': phone,
      'email': email,
      'assistant_name': assistantData['name'],
      'assistant_job': assistantData['job'], // Use 'job' instead of 'title'
    });
  }
}
