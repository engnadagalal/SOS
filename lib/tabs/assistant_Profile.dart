import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssistantProfile extends StatefulWidget {
  @override
  _AssistantProfileState createState() => _AssistantProfileState();
}

class _AssistantProfileState extends State<AssistantProfile> {
  // Get the FirebaseAuth instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Access UID, email, and display name
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;

  String _name = FirebaseAuth.instance.currentUser?.displayName ?? '';
  String _email = FirebaseAuth.instance.currentUser?.email ?? '';
  String _phone = '';
  String _address = '';
  String _price = '';
  String _job = '';
  String _photoUrl = 'assets/images/profile_placeholder.png';

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _jobController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the current user data
    _fullnameController.text = _name;
    _emailController.text = _email;
    _phoneController.text = _phone;
    _addressController.text = _address;
    _priceController.text = _price;
    _jobController.text = _job;

    // Fetch doctor info from Firestore
    _fetchDoctorInfo();
  }

  void _fetchDoctorInfo() async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('assistants').doc(uid).get();

      setState(() {
        _name = snapshot['name'] ?? '';
        _email = snapshot['email'] ?? '';
        _phone = snapshot['phone'] ?? '';
        _address = snapshot['address'] ?? '';
        _price = snapshot['price'] ?? '';
        _job = snapshot['job'] ?? '';
        
        _fullnameController.text = _name;
        _emailController.text = _email;
        _phoneController.text = _phone;
        _addressController.text = _address;
        _priceController.text = _price;
        _jobController.text = _job;
      });
    } catch (error) {
      print('Error fetching doctor info: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue, // Change this to your desired color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _changePhoto,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage(_photoUrl),
              ),
            ),
            SizedBox(height: 20.0),
            _buildTextField('Full name', _fullnameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Phone', _phoneController),
            _buildTextField('Address', _addressController),
            _buildTextField('Price', _priceController),
            _buildTextField('Job', _jobController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void _changePhoto() {
    // Implement photo change functionality
  }

  void _saveChanges() async {
    setState(() {
      _name = _fullnameController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
      _address = _addressController.text;
      _price = _priceController.text;
      _job = _jobController.text;
    });

    // Save user information to Firestore
    try {
      await firestore.collection('assistants').doc(uid).set({
        'name': _name,
        'email': _email,
        'phone': _phone,
        'address': _address,
        'price': _price,
        'job': _job,
        
      });

      print('Changes saved successfully');
    } catch (error) {
      print('Error saving changes: $error');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistant Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssistantProfile(),
    );
  }
}
