
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:samvad_seva_application/model/service_list_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceListPage extends StatefulWidget {
  final List<Service> services;
   final String categoryId;

  ServiceListPage({
    Key? key,
    required this.services,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
void addToCart(Service service, int quantity) async {
  String? userId = await getUserId();
  if (userId != null && quantity > 0) {
    var response = await http.post(
      Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/add_to_cart'),
      body: {
        'user_id': userId,
        'category_id': widget.categoryId,
        'service_id': service.serviceId,
        'product_qty': quantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added to cart successfully')),
      );
    } else {
    
      var data = json.decode(response.body);
      String errorMessage = data['messages']['status'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid quantity or user ID')),
    );
  }
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

void _showServiceDetailsModal(BuildContext context, Service service) {
  int quantity = 1;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text(service.serviceName),
                subtitle: Text('Select Quantity'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  addToCart( service, quantity);
                },
                child: Text('Add to Cart'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.2,
        ),
        itemCount: widget.services.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => _showServiceDetailsModal(context, widget.services[index]),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 Expanded(
                    child: Image.network(
                      "https://collegeprojectz.com/NEWPROJECT/uploads/${widget.services[index].serviceImage}",
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Image not available'));
                      },
                    ),
                  ),
                  Text(
                    widget.services[index].serviceName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis, 
                    style: TextStyle(fontSize: 14)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
