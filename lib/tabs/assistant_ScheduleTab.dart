import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:sos_app/styles/colors.dart';

class ASIScheduleTab extends StatefulWidget {
  const ASIScheduleTab({Key? key}) : super(key: key);

  @override
  State<ASIScheduleTab> createState() => _ASIScheduleTabState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

class Appointment {
  final String name;
  final String title;
  final String phone;
  final String email;
  FilterStatus status;

  Appointment(this.name, this.title, this.phone, this.email, {this.status = FilterStatus.Upcoming});
}

class _ASIScheduleTabState extends State<ASIScheduleTab> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  final Random _random = Random();
  List<Appointment> appointments = []; 

  @override
  void initState() {
    super.initState();
    _fetchAppointments(); 
  }

  void _fetchAppointments() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Patient.Resv.MA').get();
    final List<Appointment> fetchedAppointments = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Appointment(data['name'], data['title'], data['phone'], data['email']);
    }).toList();

    setState(() {
      appointments = fetchedAppointments;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> filteredAppointments =
        appointments.where((appointment) => appointment.status == status).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schedule🔓',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus;
                                _updateAlignment(filterStatus);
                              });
                            },
                            child: Center(
                              child: Text(
                                filterStatus.toString().split('.').last,
                                style: TextStyle(
                                  color: status == filterStatus ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _alignment,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(MyColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.toString().split('.').last,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return AppointmentCard(
                    appointment: appointment,
                    onAccept: () {
                      setState(() {
                        appointment.status = FilterStatus.Complete;
                        _updateAlignment(FilterStatus.Complete);
                      });
                    },
                    onCancel: () {
                      setState(() {
                        appointment.status = FilterStatus.Cancel;
                        _updateAlignment(FilterStatus.Cancel);
                      });
                    },
                    onShowPatientData: () {
                      _showPatientDataDialog(context, appointment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateAlignment(FilterStatus filterStatus) {
    if (filterStatus == FilterStatus.Upcoming) {
      _alignment = Alignment.centerLeft;
    } else if (filterStatus == FilterStatus.Complete) {
      _alignment = Alignment.center;
    } else if (filterStatus == FilterStatus.Cancel) {
      _alignment = Alignment.centerRight;
    }
  }

  void _showPatientDataDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${appointment.name}'),
              Text('Title: ${appointment.title}'),
              Text('Phone: ${appointment.phone}'),
              Text('Email: ${appointment.email}'),
            ],
          ),
          actions: [
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
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final VoidCallback onShowPatientData;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.onAccept,
    required this.onCancel,
    required this.onShowPatientData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              appointment.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Adjust font size
            ),
            ElevatedButton(
              onPressed: onShowPatientData,
              child: Text('Patient Data'),
            ),
            SizedBox(height: 20), // Adjust spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (appointment.status == FilterStatus.Upcoming)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: Text('Cancel'),
                    ),
                  ),
                if (appointment.status == FilterStatus.Upcoming)
                  SizedBox(width: 20),
                if (appointment.status == FilterStatus.Upcoming)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      child: Text('Accept'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
