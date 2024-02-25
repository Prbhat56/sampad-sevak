import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samvad_seva_application/pages/home%20widget/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressFormPage extends StatefulWidget {
  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? userId = await getUserId();
      if (userId == null) {
        _showSnackBar('User ID not found. Please login again.');
        return;
      }

      var response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/add_address'),
        body: {
          "user_id": userId,
          "firstname": _firstNameController.text,
          "lastname": _lastNameController.text,
          "address1": _address1Controller.text,
          "address2": _address2Controller.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "zip": _pinCodeController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 200 && data['error'] == true) {
          _showSnackBar(data['messages']['status']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          _showSnackBar('Failed to add address: ${data['messages']['status']}');
          _clearForm();
        }
      } else {
        _showSnackBar('Error: Could not connect to the server.');
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

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _address1Controller.clear();
    _address2Controller.clear();
    _cityController.clear();
    _stateController.clear();
    _pinCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Form'),
        backgroundColor: Colors.red, // Use theme's primary color
        elevation: 0, // Remove the shadow for a cleaner look
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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(
                controller: _firstNameController,
                labelText: 'First Name',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _phoneController,
                labelText: 'Phone',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _address1Controller,
                labelText: 'Address 1',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _address2Controller,
                labelText: 'Address 2',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _cityController,
                labelText: 'City',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _stateController,
                labelText: 'State',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: _pinCodeController,
                labelText: 'Pin-Code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Pin-Code';
                  }
                  if (value.length != 6) {
                    return 'Pin-Code should be 6 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('SUBMIT'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Use the theme's primary color
                  onPrimary: Colors.white, // Text color for the button
                  shape: StadiumBorder(), // Stadium shaped border
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null
            ? Icon(icon, color: Theme.of(context).primaryColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}
