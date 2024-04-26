import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/componente.dart';
import '../Register/verify.dart';
import '../Register/who.dart';
import '../doctor/Home.dart';

class d_login extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          const Image(
            image: AssetImage(
              'assets/images/logo-1-sos.png',
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'sign in to access your account',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                labelText: 'Enter your email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          PasswordTextField(
            controller: _passwordController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Verify(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 255, 1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 250,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () async {
                try {
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  // After the user is logged in, check if the user is a doctor
                  DocumentSnapshot docSnapshot = await _firestore.collection('doctors').doc(userCredential.user!.uid).get();
                  if (docSnapshot.exists) {
                    // The user is a doctor, navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } else {
                    // The user is not a doctor, handle accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You are not a doctor'),
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                  // Handle the error according to your needs
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred: $e'),
                    ),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: defultColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New Member?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const whoscrean(),
                      ),
                    );
                  },
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 255, 1),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: defultColor,
    );
  }
}