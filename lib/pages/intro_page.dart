import 'package:flutter/material.dart';

import 'package:samvad_seva_application/pages/login_page.dart';
import 'package:samvad_seva_application/pages/registration_page.dart';


class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
    @override
      void initState() {
    super.initState();
   
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
          
            return RegistrationPage();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
       color: Color.fromRGBO(202, 57, 56, 1),
       
      ),
      child: Center(
        child: Image.asset(
          "assets/1.jpg",
          ),
      ),
      )
    );
  }
}
