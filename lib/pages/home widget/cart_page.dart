// import 'package:flutter/material.dart';
// import 'package:samvad_seva_application/model/service_item.dart';
// import 'package:samvad_seva_application/pages/confirmation_page/order_confirm_page.dart';
// import 'package:samvad_seva_application/pages/setting_pages/address_page.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   bool _payOnlineSelected = false;
//   final TextEditingController _couponController = TextEditingController();

//   List<ServiceItem> services = [
//     const ServiceItem(
//       serviceName: 'Windows AC installation',
//       price: 'Rs. 1000 X 1',
//       total: 'Total: Rs. 1000',
//       imagePath: 'https://media.istockphoto.com/id/919430344/photo/close-up-view-of-hand-operating-air-conditioner-remote-control.webp?b=1&s=170667a&w=0&k=20&c=CfVzWjPcIpJPkeOtDboT2BMfY_rGbZBfTCefNtFTJsk=', 
//     ),
//     const ServiceItem(
//       serviceName: 'AC Wet Service (Indoor)',
//       price: 'Rs. 800 X 1',
//       total: 'Total: Rs. 800',
//       imagePath: 'https://media.istockphoto.com/id/919430344/photo/close-up-view-of-hand-operating-air-conditioner-remote-control.webp?b=1&s=170667a&w=0&k=20&c=CfVzWjPcIpJPkeOtDboT2BMfY_rGbZBfTCefNtFTJsk=',
//     ),
   
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.red,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ...services.map((service) => Dismissible(
//                   key: Key(service.serviceName),
//                   onDismissed: (direction) {
//                     setState(() {
//                       services.remove(service);
//                     });
//                   },
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                     child: service,
//                   ),
//                 )),

//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _couponController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter Coupon Code',
//                         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(primary: Colors.red),
//                     onPressed: () {},
//                     child: const Text('Apply'),
//                   ),
//                 ],
//               ),
//             ),

        
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//   child: Container(
//     padding: const EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 1,
//           blurRadius: 6,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Name: sam sahoo', style: TextStyle(fontSize: 16)),
//         SizedBox(height: 4),
//         Text('Contact No: 7008170926', style: TextStyle(fontSize: 16)),
//         SizedBox(height: 4),
//         Text('E-Mail: samir@gmail.com', style: TextStyle(fontSize: 16)),
//         SizedBox(height: 4),
//         Text('Address 1: ajaxaddress', style: TextStyle(fontSize: 16)),
//         SizedBox(height: 14), // Spacing before the button
//         SizedBox(
//           width: double.infinity, // Makes the button stretch to fill the width
//           height: 48, // Sets a fixed height for the button
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: const Color.fromARGB(255, 187, 183, 183), 
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(2), 
//               ),
//             ),
//             onPressed: () {
//                 Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>  AddressFormPage()));
//             },
//             child: Text(
//               'Change Address',
//               style: TextStyle(
//                 color: Colors.white, // Text color
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),



//           Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     children: [
//       Expanded(
//         child: OutlinedButton.icon(
//           onPressed: () {
        
//           },
//           icon: Icon(Icons.calendar_today, size: 20), 
//           label: Text('Date'),
//         ),
//       ),
//       const SizedBox(width: 8),
//       Expanded(
//         child: OutlinedButton.icon(
//           onPressed: () {

//           },
//           icon: Icon(Icons.access_time, size: 20), 
//           label: Text('Time'),
//         ),
//       ),
//     ],
//   ),
// ),

// // Pricing details
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text('Total: Rs.2900/-'),
//       Text('Coupon Price: Rs.0/-'),
//       Text('GST 0%: Rs.0/-'),
//     ],
//   ),
// ),

// // Payment selection
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     children: [
//       Expanded(
//         child: ListTile(
//           title: const Text('Pay On Visit'),
//           leading: Radio<bool>(
//             value: false,
//             groupValue: _payOnlineSelected,
//             onChanged: (bool? value) {
//               setState(() {
//                 _payOnlineSelected = value!;
//               });
//             },
//           ),
//         ),
//       ),
//       Expanded(
//         child: ListTile(
//           title: const Text('Pay Online'),
//           leading: Radio<bool>(
//             value: true,
//             groupValue: _payOnlineSelected,
//             onChanged: (bool? value) {
//               setState(() {
//                 _payOnlineSelected = value!;
//               });
//             },
//           ),
//         ),
//       ),
//     ],
//   ),
// ),

//             // Checkout button
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(primary: Colors.blue),
//                   onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const OrderConfirmationPage()));
//                   },
//                   child: const Text('CHECK OUT (RS.2900)'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }