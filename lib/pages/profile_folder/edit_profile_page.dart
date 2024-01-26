import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:samvad_seva_application/pages/home%20widget/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      String? userId = await getUserId();
      if (userId == null) {
        _showSnackBar('User ID not found. Please login again.');
        return;
      }
      var response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/update_profile'),
        body: {
          "user_id": userId,
          "full_name": _nameController.text,
          "e_mail": _emailController.text,
          "contact_number": _phoneController.text,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 200 && data['error'] == true) {
          _showSnackBar('Update Data Successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        } else {
          _showSnackBar('Failed to update profile');
        }
      } else {
        _showSnackBar('Error: Could not connect to server');
      }
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Edit Profile'),
      backgroundColor: Colors.red, 
      elevation: 0, 
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ), // Custom back button
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30),
              Icon(Icons.edit,
              size: 35,),
              const SizedBox(height: 30),
              buildTextField(
                controller: _nameController,
                labelText: 'Name',
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _phoneController,
                labelText: 'Phone No',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 300),
              ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
