import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Restaurant Finder',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: RestaurantPage(),
  ));
}

class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with SingleTickerProviderStateMixin {
  String _selectedOption = '';
  String? _selectedLocation;
  String? _selectedRating;
  late final AnimationController _animationController;
  final Map<String, List<String>> _subOptions = {
    'Location': ['Tambaram', 'T.Nagar', 'Velachery'],
    'Rating': ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars']
  };

  String? _restaurantName;
  String? _restaurantAddress;
  String? _restaurantDescription;
  String? _restaurantContact;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOption == option) {
        _selectedOption = ''; // Hide options if the same category is clicked again
        _animationController.reverse();
      } else {
        _selectedOption = option;
        _animationController.forward();
      }
    });
  }

  bool _areAllOptionsSelected() {
    return _selectedLocation != null && _selectedRating != null;
  }

  Future<void> _fetchRestaurantDetails() async {
    final response = await http.post(
      Uri.parse('http://10.196.221.144:5000/get_restaurant_details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': _selectedLocation,
        'rating': _selectedRating,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _restaurantName = data['name'];
        _restaurantAddress = data['address'];
        _restaurantDescription = data['description'];
        _restaurantContact = data['contact'];
        _error = null;
      });
    } else {
      setState(() {
        _error = 'No matching restaurant details found.';
        _restaurantName = null;
        _restaurantAddress = null;
        _restaurantDescription = null;
        _restaurantContact = null;
      });
    }
  }

  void _handleEnterButtonPress() async {
    await _fetchRestaurantDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // Location Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Location'),
                      onTap: () => _toggleOption('Location'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'Location',
                        child: Column(
                          children: _subOptions['Location']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedLocation,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedLocation = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedLocation = subOption;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                // Rating Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Rating'),
                      onTap: () => _toggleOption('Rating'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'Rating',
                        child: Column(
                          children: _subOptions['Rating']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedRating,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRating = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedRating = subOption;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Display restaurant details if available
          if (_restaurantName != null && _restaurantAddress != null && _restaurantDescription != null && _restaurantContact != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name: $_restaurantName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Address: $_restaurantAddress'),
                  Text('Description: $_restaurantDescription'),
                  Text('Contact: $_restaurantContact'),
                ],
              ),
            ),
          // Display error if no details found
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _areAllOptionsSelected() ? _handleEnterButtonPress : null,
                child: Text('Enter'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
