import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? userId; 

  @override
  void initState() {
    super.initState();
    getUserId(); 
  }

 Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

  Future<void> saveAddress() async {
    if (_formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/update_address'),
        body: {
          'address_id': '0', 
          'user_id': userId ?? '',
          'firstname': firstNameController.text,
          'lasttname': lastNameController.text,
          'address1': address1Controller.text,
          'address2': address2Controller.text,
          'city': cityController.text,
          'state': stateController.text,
          'zip': zipController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        },
      );

      if (response.statusCode == 200) {
     
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Address saved successfully')));
      } else {
    
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save address')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
          
              TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name'), validator: (value) => value!.isEmpty ? 'Please enter first name' : null),
              TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name'), validator: (value) => value!.isEmpty ? 'Please enter last name' : null),
              TextFormField(controller: address1Controller, decoration: InputDecoration(labelText: 'Address Line 1'), validator: (value) => value!.isEmpty ? 'Please enter address' : null),
              TextFormField(controller: address2Controller, decoration: InputDecoration(labelText: 'Address Line 2')),
              TextFormField(controller: cityController, decoration: InputDecoration(labelText: 'City'), validator: (value) => value!.isEmpty ? 'Please enter city' : null),
              TextFormField(controller: stateController, decoration: InputDecoration(labelText: 'State'), validator: (value) => value!.isEmpty ? 'Please enter state' : null),
              TextFormField(controller: zipController, decoration: InputDecoration(labelText: 'Zip Code'), validator: (value) => value!.isEmpty ? 'Please enter zip code' : null),
              TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email'), validator: (value) => value!.isEmpty ? 'Please enter email' : null),
              TextFormField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone'), validator: (value) => value!.isEmpty ? 'Please enter phone number' : null),
              ElevatedButton(
                onPressed: saveAddress,
                child: Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
