import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HousingPage extends StatefulWidget {
  @override
  _HousingPageState createState() => _HousingPageState();
}

class _HousingPageState extends State<HousingPage> with SingleTickerProviderStateMixin {
  String _selectedOption = '';
  String? _selectedLocation;
  String? _selectedPrice;
  String? _selectedBhk;
  String _address = '';  // To store the fetched address
  late final AnimationController _animationController;
  final Map<String, List<String>> _subOptions = {
    'Location': ['Tambaram', 'T.Nagar', 'Velachery'],
    'Price': ['₹30L - ₹50L', '₹50L - ₹80L', '₹80L+'],
    'BHK': ['1 BHK', '2 BHK', '3 BHK', '4 BHK']
  };

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

  bool _isAllOptionsSelected() {
    return _selectedLocation != null && _selectedPrice != null && _selectedBhk != null;
  }

  Future<void> _fetchAddress() async {
    final response = await http.get(Uri.parse(
      'http://10.196.221.144:5000/get-address?location=$_selectedLocation&price=$_selectedPrice&bhk=$_selectedBhk'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _address = jsonResponse['address'];
      });
      _showAddressDialog(_address);
    } else {
      setState(() {
        _address = 'Failed to load address';
      });
    }
  }

  void _showAddressDialog(String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Address'),
          content: Text(address),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmSelection() {
    if (_isAllOptionsSelected()) {
      _fetchAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Housing'),
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
                // Price Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Price'),
                      onTap: () => _toggleOption('Price'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'Price',
                        child: Column(
                          children: _subOptions['Price']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedPrice,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedPrice = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedPrice = subOption;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                // BHK Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('BHK'),
                      onTap: () => _toggleOption('BHK'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'BHK',
                        child: Column(
                          children: _subOptions['BHK']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedBhk,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedBhk = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedBhk = subOption;
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
          // Button centered at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _isAllOptionsSelected() ? _confirmSelection : null,
                child: Text('Enter'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
