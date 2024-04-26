import 'package:flutter/material.dart';
import 'register_assistant.dart';
import 'register_patient.dart';

import '../../shared/componente.dart';
import 'register_doctor.dart';

class whoscrean extends StatefulWidget {
  const whoscrean({Key? key}) : super(key: key);

  @override
  State<whoscrean> createState() => _whoscreanState();
}

class _whoscreanState extends State<whoscrean> {
  String _selectedItem = 'Doctor';
  void _navigateToPage(BuildContext context) {
    if (_selectedItem == 'Doctor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => r_doctor()),
      );
    } else if (_selectedItem == 'Assistant') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => r_assistant()),
      );
    } else if (_selectedItem == 'Patient') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => r_patient()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Image(
                image: AssetImage(
                  'assets/images/logo-1-sos.png',
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 300,
                    height: 30,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: _selectedItem,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem = newValue!;
                        });
                      },
                      items: <String>['Doctor', 'Assistant', 'Patient']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateToPage(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  defultColor2)),
                          child: const Text(
                            'Ok',
                            style: TextStyle(color: defultColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ]),
      backgroundColor: Colors.white,
    );
  }
}
