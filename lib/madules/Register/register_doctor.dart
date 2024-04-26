import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/componente.dart';
import '../Login/doctor_Login.dart';

class r_doctor extends StatefulWidget {
  @override
  State<r_doctor> createState() => _r_doctorState();
}

class _r_doctorState extends State<r_doctor> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> items = ['عنصر 1', 'عنصر 2', 'عنصر 3', 'عنصر 4'];
  bool isChecked = false;
  String selectedItem = 'عنصر 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defultColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            logo,
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'creating an account',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15.0),
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  labelText: 'Full name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    labelText: 'Valid email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    labelText: 'Phone number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 295,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: DropdownButton<String>(
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 180),
                      child:
                          Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ),
                    style: const TextStyle(fontSize: 18.0),
                    value: selectedItem,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedItem = newValue;
                      }
                    },
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '   Specialty',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(defultColor2)),
                onPressed: () async {
                  try {
                    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    // After the user is created, save the user's information in Firestore
                    await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                      'phone': _phoneController.text.trim(),
                      'specialty': selectedItem,
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => d_login()));
                  } catch (e) {
                    print(e);
                    // Handle the error according to your needs
                  }
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: defultColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already a member?',
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => d_login()));
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
                    ))
              ],
            )
          ],
        ),
      ),
      backgroundColor: defultColor,
    );
  }
}