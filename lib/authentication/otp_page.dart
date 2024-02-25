import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:samvad_seva_application/pages/home%20widget/home.dart';
import 'package:samvad_seva_application/pages/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _isCountingDown = true;
  Timer? _timer;
  bool showError = false;
  int _start = 23;

  void _verifyOTP() async {
    String otp = _controllers.map((c) => c.text).join();

 
  if (otp.length < _controllers.length || otp != "1234") {
    setState(() {
      showError = true; 
    });
    return; 
  }
    var response = await http.post(
      Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/VerifyOTP'),
      body: {'contact': widget.phoneNumber},
    );

     if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['status'] == 200 && data['error'] == true) {
      String userId = data['messages']['status']['user_id'];
      bool isLoggedIn = data['messages']['status']['isLoggedIn'] as bool; // Cast to bool
       _storeUserId(userId);
      await _storeLoggedInStatus(isLoggedIn); 

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } else {
        print('Error: ${response.body}');
      }
    } else {
      print('Error: ${response.body}');
    }
  }
  Future<void> _storeLoggedInStatus(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

  Future<bool> _onBackPressed() async {
    for (var i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        setState(() {
          _controllers[i].text = _controllers[i]
              .text
              .substring(0, _controllers[i].text.length - 1);
        });
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  void _storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isCountingDown = true; // Start countdown
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isCountingDown = false; // Countdown finished
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildOTPField({required int index}) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _controllers[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:showError ? Colors.red : Colors.blue, width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: showError ? Colors.red : Colors.blue, width: 2.0),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index != _controllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Image.asset("assets/1.jpg"),
                ),
                const SizedBox(height: 60),
                const Text(
                  'OTP Verification',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter OTP sent to your mobile no +91-${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(4, (index) => _buildOTPField(index: index)),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_start sec Remaining',
                  style: const TextStyle(fontSize: 16),
                ),
                if (!_isCountingDown)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Resend OTP'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Text('Edit Mobile Number'),
                ),
                const SizedBox(height: 7,),
                  if (showError)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Please enter OTP to proceed",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
