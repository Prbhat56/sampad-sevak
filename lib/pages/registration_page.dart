import 'package:flutter/material.dart';
import 'package:samvad_seva_application/authentication/otp_page.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController phoneController = TextEditingController();
  bool isloading = false;

  Future<void> loginWithOTP() async {
     setState(() {
      isloading = true; 
    });
    if (phoneController.text.length == 10) {
      var response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/LoginOTP'),
        body: {'contact': phoneController.text},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OTPScreen(phoneNumber: phoneController.text)),
        );
      } else {
        print('Error: ${response.body}');
        final snackBar = SnackBar(content: Text('Error: ${response.body}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(content: Text('Please enter a valid number'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      setState(() {
      isloading = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
           SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Image.asset(
                  "assets/1.jpg",
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Let's Get Started",
                    style: TextStyle(
                      color: Color(0xFF111719),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter your mobile number',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF111719),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(4)),
                      ),
                      child: const Text(
                        '+91-',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '9937******',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(202, 57, 56, 1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: loginWithOTP,
                    child: const Text(
                      'GET OTP',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
          isloading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
      ],
      ),
    );
  }
}
