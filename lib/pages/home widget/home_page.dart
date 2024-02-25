import 'package:flutter/material.dart';

import 'package:samvad_seva_application/constant/offers.dart';

import 'package:samvad_seva_application/constant/services.dart';
import 'package:samvad_seva_application/model/sub_category_model.dart';
import 'package:samvad_seva_application/new_service/new_service_data_model.dart';
import 'package:samvad_seva_application/new_service/new_service_page.dart';

import 'package:http/http.dart' as http;
import 'package:samvad_seva_application/pages/registration_page.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/city_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int subcategorySelectionCount = 0;
  List<Category> categories = [];
  bool isCitySelected = false;

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<List<City>> fetchCities() async {
    String? userId = await getUserId();
    if (userId == null) {
      throw Exception('User ID not found');
    }

    var url =
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/select_city');
    var response = await http.post(url, body: {"user_id": userId});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<City> cities = (data['messages']['status']['city'] as List)
          .map((cityJson) => City.fromJson(cityJson))
          .toList();
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
  Future<void> _showLogoutConfirmationDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close the dialog.
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              const Icon(Icons.power_settings_new, size: 30, color: Colors.redAccent),
              const SizedBox(height: 25),
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    ),
                    child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog first
                      _logout();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all data stored in SharedPreferences.

    // Navigate to the login page after clearing SharedPreferences.
    // Make sure to replace 'LoginPage()' with your actual login page widget.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
      (Route<dynamic> route) => false,
    );
  }

  void storeCityId(String? cityId) async {
    if (cityId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city_id', cityId);
    }
  }

  List<dynamic> searchResults = [];
  List<City> cities = [];

  @override
  void initState() {
    super.initState();
    _initializePage();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      cities = await fetchCities();
    } catch (error) {
      print("Error fetching cities: $error");
    }
  }

  void search(String query) {
    if (query.isNotEmpty) {
      final filteredCategories = categories
          .where((category) =>
              category.catName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      final filteredCities = cities
          .where((city) =>
              city.cityName.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        searchResults = [...filteredCategories, ...filteredCities];
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<void> _initializePage() async {
    final cityId = await getCityId();
    if (cityId != null) {
      var cities = await fetchCities();
      City selectedCity = cities.firstWhere(
        (city) => city.cityId == cityId,
        orElse: () =>
            City(cityId: '', cityName: ''), // Provide a default City object
      );
      if (selectedCity.cityId.isNotEmpty) {
        // Check if the cityId is not empty
        _locationController.text = selectedCity.cityName;
        setState(() {
          isCitySelected = true;
        });
        await _loadCategories();
      } else {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _showLocationDialog());
      }
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showLocationDialog());
    }
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (error) {
      print("Error loading categories: $error");
    }
  }

  void _showLocationDialog() async {
    var cities = await fetchCities();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? selectedCityId;
        return AlertDialog(
          title: const Text('Select Your Location'),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          content: DropdownButtonFormField<String>(
            items: cities.map<DropdownMenuItem<String>>((City city) {
              return DropdownMenuItem<String>(
                value: city.cityId,
                child: Text(city.cityName),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedCityId = newValue;
            },
            decoration: const InputDecoration(
              labelText: 'City',
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (selectedCityId != null) {
                  City selectedCity = cities.firstWhere(
                    (city) => city.cityId == selectedCityId,
                    orElse: () => City(cityId: '', cityName: ''),
                  );
                  if (selectedCity.cityName.isNotEmpty) {
                    _locationController.text = selectedCity.cityName;
                    storeCityId(selectedCityId);
                    setState(() {
                      isCitySelected = true;
                    });
                    await fetchCategories().then((fetchedServices) {
                      setState(() {
                        categories = fetchedServices;
                      });
                    }).catchError((error) {
                      print("Error fetching services: $error");
                    });
                  }
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Service>> fetchServices(
      String userId, String cityId, String categoryId) async {
    var url = Uri.parse(
        'https://collegeprojectz.com/NEWPROJECT/API/user_service_list');
    var response = await http.post(url, body: {
      "user_id": userId,
      "city_id": cityId,
      "category_id": categoryId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Service> services =
          (data['messages']['status']['service_list'] as List)
              .map((serviceJson) => Service.fromJson(serviceJson))
              .toList();
      return services;
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<Offer>> fetchOffers() async {
    String? userId = await getUserId();
    String? cityId = await getCityId();

    if (userId == null || cityId == null) {
      throw Exception('User ID or City ID not found');
    }

    var url = Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/user_home');
    var response = await http.post(url, body: {
      "user_id": userId,
      "city_id": cityId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Offer> offers = (data['messages']['status']['offer_dtl'] as List)
          .map((offerJson) => Offer.fromJson(offerJson))
          .toList();
      return offers;
    } else {
      throw Exception('Failed to load offers');
    }
  }

  Future<List<Subcategory>> fetchSubcategories(String catId) async {
    String? userId = await getUserId();
    String? cityId = await getCityId();

    if (userId == null || cityId == null) {
      throw Exception('User ID or City ID not found');
    }

    var url =
        Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/SubCategory');
    var response = await http.post(url, body: {
      "user_id": userId,
      "city_id": cityId,
      "cat_id": catId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Subcategory> subcategories =
          (data['messages']['status']['category_dtl'] as List)
              .map((subcatJson) => Subcategory.fromJson(subcatJson))
              .toList();
      return subcategories;
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  Future<String?> getCityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city_id');
  }

  Future<List<Category>> fetchCategories() async {
    String? userId = await getUserId();
    String? cityId = await getCityId();

    if (userId == null || cityId == null) {
      throw Exception('User ID or City ID not found');
    }

    var url = Uri.parse('https://collegeprojectz.com/NEWPROJECT/API/user_home');
    var response = await http.post(url, body: {
      "user_id": userId,
      "city_id": cityId,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("Fetched data: $data");
      List<Category> categories =
          (data['messages']['status']['category_dtl'] as List)
              .map((catJson) => Category.fromJson(catJson))
              .toList();
      return categories;
    } else {
      print("Failed to load categories, Status code: ${response.statusCode}");
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
      await _showLogoutConfirmationDialog();
      return false; // Prevent the back button from closing the page immediately.
    },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 27),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      _showLocationDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_city),
                          const SizedBox(width: 8.0),
                          Text(
                            _locationController.text.isEmpty
                                ? 'Enter Location'
                                : _locationController.text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image.network(
                    'https://media.istockphoto.com/id/171314675/photo/female-plumber.webp?b=1&s=170667a&w=0&k=20&c=T7ZoF14se3i9wTXUDAwlD8esR4IId1RHrMHT9br5fV0=',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Could not load image'));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (String query) {
                      search(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for meals or area',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      isDense: true,
                    ),
                  ),
                ),
                if (searchResults.isNotEmpty)
                  buildSearchResultsList(searchResults),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Our services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                buildServicesGrid(),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Offers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (isCitySelected)
                  FutureBuilder<List<Offer>>(
                    future: fetchOffers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Offer offer = snapshot.data![index];
                              return Container(
                                margin: const EdgeInsets.only(
                                    right:
                                        10), // Add margin between Offer widgets
                                padding: const EdgeInsets.all(
                                    10), // Add padding inside the Offer widget
                                child: Image.network(
                                  "https://collegeprojectz.com/NEWPROJECT/uploads/${offer.imageUrl}",
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress.expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace? stackTrace) {
                                    return const Text('Failed to load image');
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Text("No offers available");
                      }
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget buildServicesGrid() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 3 items per row
      crossAxisSpacing: 10,
      mainAxisSpacing: 28, 
      childAspectRatio: 1 / 1.4, 
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      var category = categories[index];
      return InkWell(
          onTap: () async {
         
          List<Subcategory> subcategories = await fetchSubcategories(category.catId);
         
          _showSubcategoryModal(context, subcategories);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  "https://collegeprojectz.com/NEWPROJECT/uploads/${categories[index].catImage}",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8), // Space between the card and the text
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  categories[index].catName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true, // Wrap the text
                  overflow: TextOverflow.visible, // Make overflow visible
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
  void _showSubcategoryModal(BuildContext context, List<Subcategory> subcategories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 28,
            ),
            itemCount: subcategories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                      onTap: () async {
                  if (subcategorySelectionCount == 1) {
                    String? userId = await getUserId();
                    String? cityId = await getCityId();
                    if (userId != null && cityId != null) {
                      try {
                        List<Service> services = await fetchServices(
                            userId, cityId, subcategories[index].catId);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceListPage(
                              services: services,
                            catId: subcategories[index]
                                  .catId, // Pass the name here
                            ),
                          ),
                        );
                      } catch (error) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error fetching services: $error")));
                      }
                    }
                    subcategorySelectionCount = 0;
                  } else {
                    fetchSubcategories(subcategories[index].catId)
                        .then((newSubcategories) {
                      Navigator.pop(context); // Close the current modal
                      _showSubcategoryModal(context, newSubcategories);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Error fetching subcategories: $error")));
                    });
                    subcategorySelectionCount++;
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          "https://collegeprojectz.com/NEWPROJECT/uploads/${subcategories[index].catImg}",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          subcategories[index].catName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildSearchResultsList(List<dynamic> results) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        if (item is Category) {
          return ListTile(
            title: Text(item.catName),
            // Add additional UI elements or onTap functionality if needed
          );
        } else if (item is City) {
          return ListTile(
            title: Text(item.cityName),
            // Add additional UI elements or onTap functionality if needed
          );
        }
        return Container(); // Fallback for non-matching types
      },
    );
  }
}
