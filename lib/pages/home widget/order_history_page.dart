import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samvad_seva_application/pages/home%20widget/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:samvad_seva_application/constant/order.dart';


class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool isLoading = true;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    String? userId = await getUserId();
    var response = await http.post(
      Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/customer_allorder'),
      body: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 200 && data['error'] == true) {
        List<dynamic> ordersData = data['messages']['status']['Orderdtls'];
        setState(() {
          orders = ordersData.map((json) => Order.fromJson(json)).toList();
          isLoading = false;
        });
      }
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Order History'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/noorder.png",
                      height: 200, // Increase the size of the image
                      width: 200,
                    ),
                    const SizedBox(height: 20), 
                    const Text(
                      'No Orders Found',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 40), // Add more spacing before the button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home())); // This assumes your home page is the previous page in the stack.
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Use your theme color here
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Add some padding
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    Order order = orders[index];
                    return const Card(
                     
                        );
                  },
                ),
    );
  }
}
