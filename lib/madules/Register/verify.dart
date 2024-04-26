import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
// Import Cloud Firestore


class Verify extends StatelessWidget {
  const Verify({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/didabluemedi.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color.fromARGB(233, 251, 250, 250)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                        labelText: 'Enter your email',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.8), // Adjust opacity as needed
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(117, 12, 12, 12)),
                      ),
                      onPressed: () {
                        _sendPasswordResetEmail(context, emailController.text);
                      },
                      child: Text(
                        'Send Reset Email',
                        style: TextStyle(color: Colors.white), // Change the color here
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(0, 251, 250, 250), // Make the background transparent to let the image show
    );
  }

  // Function to send a password reset email
  void _sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send password reset email. Please try again later.'),
        ),
      );
    }
  }
}
