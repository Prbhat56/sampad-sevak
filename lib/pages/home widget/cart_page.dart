import 'package:flutter/material.dart';
import 'package:samvad_seva_application/model/service_item.dart';
import 'package:samvad_seva_application/pages/confirmation_page/order_confirm_page.dart';
import 'package:samvad_seva_application/pages/setting_pages/address_page.dart';



class CartPage extends StatefulWidget {
  final List<ServiceItem> services;
  final int totalPrice;

  const CartPage({super.key, required this.services, required this.totalPrice});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _payOnlineSelected = false;
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...widget.services.map((service) => Dismissible(
                  key: Key(service.serviceName),
                  onDismissed: (direction) {
                    setState(() {
                      widget.services.remove(service);
                    });
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      // Assuming ServiceItem has these properties. Adjust according to your ServiceItem class
                      leading: Image.network(
                        service.image, // Replace with actual image URL property
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                      title: Text(service.serviceName), // Replace with actual service name property
                      // Add other details you want to show for each service item
                    ),
                  ),
                )).toList(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Coupon Code',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {},
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),

        
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: sam sahoo', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('Contact No: 7008170926', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('E-Mail: samir@gmail.com', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('Address 1: ajaxaddress', style: TextStyle(fontSize: 16)),
        SizedBox(height: 14), // Spacing before the button
        SizedBox(
          width: double.infinity, // Makes the button stretch to fill the width
          height: 48, // Sets a fixed height for the button
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 187, 183, 183), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2), 
              ),
            ),
            onPressed: () {
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  AddressFormPage()));
            },
            child: Text(
              'Change Address',
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),



          Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
        
          },
          icon: Icon(Icons.calendar_today, size: 20), 
          label: Text('Date'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {

          },
          icon: Icon(Icons.access_time, size: 20), 
          label: Text('Time'),
        ),
      ),
    ],
  ),
),

// Pricing details
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Total: Rs.2900/-'),
      Text('Coupon Price: Rs.0/-'),
      Text('GST 0%: Rs.0/-'),
    ],
  ),
),

// Payment selection
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Expanded(
        child: ListTile(
          title: const Text('Pay On Visit'),
          leading: Radio<bool>(
            value: false,
            groupValue: _payOnlineSelected,
            onChanged: (bool? value) {
              setState(() {
                _payOnlineSelected = value!;
              });
            },
          ),
        ),
      ),
      Expanded(
        child: ListTile(
          title: const Text('Pay Online'),
          leading: Radio<bool>(
            value: true,
            groupValue: _payOnlineSelected,
            onChanged: (bool? value) {
              setState(() {
                _payOnlineSelected = value!;
              });
            },
          ),
        ),
      ),
    ],
  ),
),

            // Checkout button
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderConfirmationPage()));
                  },
                  child: const Text('CHECK OUT (RS.2900)'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}