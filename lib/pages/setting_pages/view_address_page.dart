import 'package:flutter/material.dart';
import 'package:samvad_seva_application/pages/setting_pages/address_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ViewAddressPage extends StatefulWidget {
  @override
  _ViewAddressPageState createState() => _ViewAddressPageState();
}

class _ViewAddressPageState extends State<ViewAddressPage> {
  Map<String, dynamic>? _addressData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? cityId = prefs.getString('city_id');

    if (userId == null || cityId == null) {
      setState(() => _isLoading = false);
      return;
    }

    var url = Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/user_home');
    var response = await http.post(url, body: {
      'user_id': userId,
      'city_id': cityId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 200 && data['error']) {
        setState(() {
          _addressData = data['messages']['status']['user_dtl'][0];
        });
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Text('Your Address'),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _addressData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Address Details:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10),
                      Text(_addressData!['address1'] ?? 'Not found'),
                      Text(_addressData!['address2'] ?? ''),
                      Text(_addressData!['city'] ?? ''),
                      Text(_addressData!['state'] ?? ''),
                      Text(_addressData!['pin'] ?? ''),
                    ],
                  ),
                )
              : Center(
                  child: Text('Address not found.'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddressFormPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
