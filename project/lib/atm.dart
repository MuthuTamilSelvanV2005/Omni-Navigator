import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ATMPage extends StatefulWidget {
  @override
  _ATMPageState createState() => _ATMPageState();
}

class _ATMPageState extends State<ATMPage> with SingleTickerProviderStateMixin {
  String _selectedOption = '';
  String? _selectedLocation;
  String? _selectedBranch;
  String _atmDetails = '';  // To store the fetched ATM details
  late final AnimationController _animationController;
  final Map<String, List<String>> _subOptions = {
    'Location': ['Tambaram', 'T.Nagar', 'Velachery'],
    'Branch': ['SBI', 'AXIS', 'ICICI']
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
    return _selectedLocation != null && _selectedBranch != null;
  }

  Future<void> _fetchATMDetails() async {
    final response = await http.get(Uri.parse(
      'http://10.196.221.144:5000/get-atm?location=$_selectedLocation'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _atmDetails = jsonResponse['atms'].join('\n');
      });
      _showATMDetailsDialog(_atmDetails);
    } else {
      setState(() {
        _atmDetails = 'Failed to load ATM details';
      });
    }
  }

  void _showATMDetailsDialog(String atmDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ATM Details'),
          content: Text(atmDetails),
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
      _fetchATMDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM Locator'),
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
                // Branch Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Branch'),
                      onTap: () => _toggleOption('Branch'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'Branch',
                        child: Column(
                          children: _subOptions['Branch']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedBranch,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedBranch = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedBranch = subOption;
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
