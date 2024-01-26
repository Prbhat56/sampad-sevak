import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samvad_seva_application/model/service_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstCartPage extends StatefulWidget {
  const FirstCartPage({Key? key}) : super(key: key);

  @override
  State<FirstCartPage> createState() => _FirstCartPageState();
}

class _FirstCartPageState extends State<FirstCartPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<ServiceItem>> _loadCartItems() async {
    try {
      final userId = await getUserId();
      final cityId = await getCityId();

      final response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/View_cart'),
        body: {
          'user_id': userId,
          'city_id': cityId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final List<dynamic> cartItems =
            responseData['messages']['status']['All_cart'];
        return cartItems
            .map<ServiceItem>((json) => ServiceItem.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<String> _removeCartItem(String cartId) async {
    try {
      final response = await http.post(
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/Remove_cart'),
        body: {
          'cart_id': cartId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['messages']
            ['status']; // Return the message from the response
      }
      return "Failed to connect to the server";
    } catch (e) {
      print("Error removing cart item: $e");
      return "Error removing cart item";
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getCityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<ServiceItem>>(
        future: _loadCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? buildEmptyCart()
                : buildCartList(snapshot.data!);
          } else {
            return buildEmptyCart();
          }
        },
      ),
    );
  }

  Widget buildCartList(List<ServiceItem> services) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...services.map((service) => buildCartItem(service)).toList(),
          const SizedBox(height: 35),
          buildCheckoutButton(services),
        ],
      ),
    );
  }

  Widget buildCartItem(ServiceItem service) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Image.network(
          "https://collegeprojectz.com/NEWPROJECT/uploads/${service.image}",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        ),
        title: Text(service.serviceName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text('Qty: ${service.qty}'),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              Text('₹${service.price}'),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () async {
                  String message =
                      (await _removeCartItem(service.cartId)) as String;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                  if (!message.contains("Error")) {
                  
                    setState(
                        () {}); 
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckoutButton(List<ServiceItem> services) {
    int total = services.fold(0, (sum, item) => sum + int.parse(item.price));
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {},
          child: Text('CHECK OUT (Rs. $total)'),
        ),
      ),
    );
  }

  Widget buildEmptyCart() {
    return Center(
      child: Text('No items in cart', style: TextStyle(fontSize: 24)),
    );
  }
}
