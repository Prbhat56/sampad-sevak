import 'package:flutter/material.dart';
import 'package:samvad_seva_application/constant/service_detail.dart';


class ServiceDetailsScreen extends StatefulWidget {
 

 const   ServiceDetailsScreen({Key? key, }) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
    late List<ServiceDetail> services1;

  @override
  void initState() {
    super.initState();
    services1 = [
  ServiceDetail(
    title: "AC Dry Service",
    description: "XYZXYZ",
    imageUrl: "https://media.istockphoto.com/id/1346484720/photo/stressed-woman-has-problem-with-the-air-conditioner-at-home.webp?b=1&s=170667a&w=0&k=20&c=mzOV9Fl8Uj1dPvgK9ARwlgRAjWuDO3zIctMg-yhnHgU=",
    price: "Rs. 500/-",
  ),
  ServiceDetail(
    title: "AC Wet Service (Indoor)",
    description: "XYZXYZ",
    imageUrl: "https://media.istockphoto.com/id/1346484720/photo/stressed-woman-has-problem-with-the-air-conditioner-at-home.webp?b=1&s=170667a&w=0&k=20&c=mzOV9Fl8Uj1dPvgK9ARwlgRAjWuDO3zIctMg-yhnHgU=",
    price: "Rs. 500/-",
  ),
    ServiceDetail(
    title: "AC Wet Service (Indoor)",
    description: "XYZXYZ",
    imageUrl: "https://media.istockphoto.com/id/1346484720/photo/stressed-woman-has-problem-with-the-air-conditioner-at-home.webp?b=1&s=170667a&w=0&k=20&c=mzOV9Fl8Uj1dPvgK9ARwlgRAjWuDO3zIctMg-yhnHgU=",
    price: "Rs. 500/-",
  ),
    ServiceDetail(
    title: "AC Wet Service (Indoor)",
    description: "XYZXYZ",
    imageUrl: "https://media.istockphoto.com/id/1346484720/photo/stressed-woman-has-problem-with-the-air-conditioner-at-home.webp?b=1&s=170667a&w=0&k=20&c=mzOV9Fl8Uj1dPvgK9ARwlgRAjWuDO3zIctMg-yhnHgU=",
    price: "Rs. 500/-",
  ),
 
];
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Service Details of Split AC'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
       
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart icon press
            },
          ),
          // More actions if needed
        ],
      ),
         body: ListView.builder(
      itemCount: services1.length,
      itemBuilder: (context, index) {
        var service = services1[index];
        return Card(
          child: ListTile(
            leading: Image.network(service.imageUrl),
            title: Text(service.title),
            subtitle: Text(service.description),
            trailing: Column(
              mainAxisSize: MainAxisSize.min, // Use the minimum space
              crossAxisAlignment: CrossAxisAlignment.end, // Align to the right
              children: [
                Text(
                  service.price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4), // Space between price and button
                ElevatedButton(
                  onPressed: () {
                    // Handle add action
                  },
                  child: const Text('ADD'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Button color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder( // Make the button rectangular
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
                    // You can adjust the padding to change the size
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
}