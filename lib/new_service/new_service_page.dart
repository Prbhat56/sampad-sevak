import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samvad_seva_application/new_service/new_service_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:samvad_seva_application/pages/home%20widget/first_cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceListPage extends StatefulWidget {
  final List<Service> services;
  final String catId;

  const ServiceListPage({
    Key? key,
    required this.services,
    required this.catId,
  }) : super(key: key);

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  Map<String, int> serviceQuantities = {};
  bool isLoading = false; // State variable for loading status

  @override
  void initState() {
    super.initState();
    for (var service in widget.services) {
      serviceQuantities[service.serviceId] = 1;
    }
  }

  Future<void> addToCart(String serviceId, int quantity) async {
    setState(() {
      isLoading = true; // Set loading to true
    });

    String? userId = await getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found")),
      );
      return;
    }

    var url = Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/addto_to_cart');
    var response = await http.post(url, body: {
      "user_id": userId,
      "service_id": serviceId,
      "category_id": widget.catId,
      "product_qty": quantity.toString(),
    });

    setState(() {
      isLoading = false; // Set loading to false
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String message = data['messages']['status'];
      bool error = data['error'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (!error) {
        // Navigate to cart page on success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstCartPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to communicate with the server")),
      );
    }
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.red,
        title: Text('Search Details of ${widget.catId}'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
             
            },
          ),
          const SizedBox(width: 16), 
        ],
      ),
      
      body: ListView.builder(
        itemCount: widget.services.length,
        itemBuilder: (context, index) {
          Service service = widget.services[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    "https://collegeprojectz.com/NEWPROJECT/uploads/${service.serviceImage}",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.serviceName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          '₹ ${service.amount}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                     Container(
                width: 180, 
                child: Row(
                  children: [
                    buildQuantitySelector(service), 
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, 
                      ),
                      onPressed: () {
                        int quantity = serviceQuantities[service.serviceId] ?? 1;
                        addToCart(service.serviceId, quantity);
                      },
                      child: const Text('ADD'),
                    ),
                  ],
                ),
              ),
                 
                ],
              ),
            ),
          );
        },
      ),
    );
  }
   Widget buildQuantitySelector(Service service) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              final currentQuantity = serviceQuantities[service.serviceId] ?? 1;
              if (currentQuantity > 1) {
                serviceQuantities[service.serviceId] = currentQuantity - 1;
              }
            });
          },
        ),
        Text('${serviceQuantities[service.serviceId] ?? 1}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              final currentQuantity = serviceQuantities[service.serviceId] ?? 1;
              serviceQuantities[service.serviceId] = currentQuantity + 1;
            });
          },
        ),
      ],
    );
  }
}
