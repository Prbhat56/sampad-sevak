import 'package:flutter/material.dart';
import 'package:samvad_seva_application/constant/order.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: ${order.orderId}'),
              Text('Order Date: ${order.orderDate.toLocal()}'),
              SizedBox(height: 20),
              Text('Service'),
              Text('Windows AC installation'),
              Text('Quantity: ${order.quantity}'),
              Text('Price: ₹${order.price.toStringAsFixed(2)}'),
              SizedBox(height: 20),
              Text('Total Price: ₹${order.total.toStringAsFixed(2)}'),
              Text('Discount: ₹${order.discount.toStringAsFixed(2)}'),
              Text('GST: ₹${order.gst.toStringAsFixed(2)}'),
              Text('Grand Total: ₹${order.grandTotal.toStringAsFixed(2)}'),
              Text('Due Amount: ₹${(order.grandTotal - order.paidAmount).toStringAsFixed(2)}'),
              Text('Paid Amount: ₹${order.paidAmount.toStringAsFixed(2)}'),
              SizedBox(height: 20),
              Text('Address Details'),
              Text('${order.address}'),
              Text('${order.city}'),
              Text('${order.state}'),
              Text('${order.pincode}'),
              SizedBox(height: 20),
              Text('Schedule At'),
              Text('Schedule Date: ${order.scheduleDate.toLocal()}'),
              Text('Schedule Time: ${order.scheduleTime}'),
              SizedBox(height: 20),
              Text('OTP'),
              Text('${order.otp}'),
              // Button to navigate back to the order history
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Order History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
