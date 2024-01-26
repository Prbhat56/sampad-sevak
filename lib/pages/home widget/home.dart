import 'package:flutter/material.dart';
import 'package:samvad_seva_application/pages/home%20widget/cart_page.dart';
import 'package:samvad_seva_application/pages/home%20widget/first_cart_page.dart';
import 'package:samvad_seva_application/pages/home%20widget/home_page.dart';
import 'package:samvad_seva_application/pages/home%20widget/order_history_page.dart';
import 'package:samvad_seva_application/pages/home%20widget/setting_page.dart';





class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late List<Widget> tabs; 
 

  @override
  void initState() {
    super.initState();
    // Initialize 'tabs' here
    tabs = [
      HomePage(),
      OrderHistoryPage(),
      FirstCartPage(), 
      SettingPage(), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: "Order History",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.shopping_basket),
            label: "Cart",
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
            backgroundColor: Colors.white
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
