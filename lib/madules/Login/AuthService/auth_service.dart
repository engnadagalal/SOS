import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future signUpWithEmailAndPassword(String email, String password, String name, String phone, String specialty) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // After the user is created, save the user's information in Firestore
      await _firestore.collection('doctors').doc(user?.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'specialty': specialty,
      });

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign In with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}