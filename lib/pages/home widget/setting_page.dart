import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samvad_seva_application/model/user_model.dart';
import 'package:samvad_seva_application/pages/home%20widget/order_history_page.dart';
import 'package:samvad_seva_application/pages/login_page.dart';
import 'package:samvad_seva_application/pages/profile_folder/edit_profile_page.dart';
import 'package:samvad_seva_application/pages/setting_pages/address_page.dart';
import 'package:samvad_seva_application/pages/setting_pages/view_address_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all data stored in SharedPreferences.

    // Navigate to the login page after clearing SharedPreferences.
    // Make sure to replace 'LoginPage()' with your actual login page widget.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData().then((data) {
      setState(() {
        _userData = data;
      });
    });
  }

  Future<UserData?> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? cityId = prefs.getString('city_id');

    if (userId == null || cityId == null) {
      return null;
    }

    var url = Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/user_home');
    var response = await http.post(url, body: {
      'user_id': userId,
      'city_id': cityId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 200 && data['error']) {
        return UserData.fromJson(data['messages']['status']['user_dtl'][0]);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            const BackButton(color: Colors.white), // If you need to handle navigation
        title: const Text('Profile'),
        backgroundColor: Colors.red,
      ),
      body: _userData == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1600486913747-55e5470d6f40?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fG1hbnxlbnwwfHwwfHx8MA%3D%3D'),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userData!.full_name.toString(),
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _userData!.email.toString(),
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 16),
                              ),
                              Text(
                                _userData!.contact_no.toString(),
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  title: const Text('Edit Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Booking List'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderHistoryPage()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('My Address'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAddressPage()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 15),
                                const Icon(Icons.power_settings_new,
                                    size: 30, color: Colors.redAccent),
                                const SizedBox(height: 25),
                                const Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.grey.shade200,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                      ),
                                      child: const Text('Cancel',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                      ),
                                      child: const Text('Logout',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog first
                                        _logout();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
