import 'package:flutter/material.dart';
import '../p_ahome/assistant_Home.dart';

import '../../shared/componente.dart';
import '../p_dhome/doctor_home.dart';

class WhoWant extends StatelessWidget {
  const WhoWant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: defultColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
              child: RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 40,
                  color: defultColor2,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: 'S'),
                TextSpan(
                  text: 'O',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'S',
                  style: TextStyle(color: defultColor2),
                ),
              ],
            ),
          )),
        ),
      ),
      backgroundColor: defultColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceBox(
              title: 'Doctor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorHome()),
                );
              },
            ),
            const SizedBox(height: 20),
            ChoiceBox(
              title: 'ِAssistant',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssistantHome()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceBox extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const ChoiceBox({super.key, required this.title, required this.onPressed});

  @override
  State<ChoiceBox> createState() => _ChoiceBoxState();
}

class _ChoiceBoxState extends State<ChoiceBox> {
  Color _color = defultColor; // لون الـ ChoiceBox عندما يتم الضغط

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // تغيير لون الـ ChoiceBox عند الضغط
          _color = defultColor2;
        });
        widget.onPressed(); // استدعاء الدالة onPressed الخاصة بالـ ChoiceBox
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(_color), // تحديد لون الـ ChoiceBox
      ),
      child: Container(
        width: 200,
        height: 100,
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
