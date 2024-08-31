import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> with SingleTickerProviderStateMixin {
  String _selectedOption = '';
  String? _selectedLocation;
  String? _selectedStyle;
  String? _selectedRating;
  late final AnimationController _animationController;
  final Map<String, List<String>> _subOptions = {
    'Location': ['Tambaram', 'T.Nagar', 'Velachery'],
    'StyleSelect': ['DualStyle', 'Men\'s Wear', 'Women\'s Wear'],
    'Rating': ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars']
  };

  String? _shopName;
  String? _shopAddress;
  String? _shopDescription;
  String? _shopContact;
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
    return _selectedLocation != null && _selectedStyle != null && _selectedRating != null;
  }

  Future<void> _fetchShopDetails() async {
    final response = await http.post(
      Uri.parse('http://10.196.221.144:5000/get_shop_details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': _selectedLocation,
        'style': _selectedStyle,
        'rating': _selectedRating,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _shopName = data['name'];
        _shopAddress = data['address'];
        _shopDescription = data['description'];
        _shopContact = data['contact'];
        _error = null;
      });
    } else {
      setState(() {
        _error = 'No matching shop details found.';
        _shopName = null;
        _shopAddress = null;
        _shopDescription = null;
        _shopContact = null;
      });
    }
  }

  void _handleEnterButtonPress() async {
    await _fetchShopDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
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
                // StyleSelect Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('StyleSelect'),
                      onTap: () => _toggleOption('StyleSelect'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'StyleSelect',
                        child: Column(
                          children: _subOptions['StyleSelect']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedStyle,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedStyle = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedStyle = subOption;
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
          // Display shop details if available
          if (_shopName != null && _shopAddress != null && _shopDescription != null && _shopContact != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name: $_shopName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Address: $_shopAddress'),
                  Text('Description: $_shopDescription'),
                  Text('Contact: $_shopContact'),
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
