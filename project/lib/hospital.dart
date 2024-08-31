import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HospitalPage(),
    );
  }
}

class HospitalPage extends StatefulWidget {
  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> with SingleTickerProviderStateMixin {
  String _selectedOption = '';
  String? _selectedLocation;
  String? _selectedSpecialization;
  late final AnimationController _animationController;
  final Map<String, List<String>> _subOptions = {
    'Location': ['Tambaram', 'T.Nagar', 'Velachery'],
    'Specialization': ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics']
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

  bool _areAllOptionsSelected() {
    return _selectedLocation != null && _selectedSpecialization != null;
  }

  Future<void> _handleEnterButtonPress() async {
    final uri = Uri.http('10.196.221.144:5000', '/hospitals', {
      'location': _selectedLocation,
      'specialization': _selectedSpecialization
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> hospitals = json.decode(response.body);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hospital Information'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var hospital in hospitals)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${hospital['name']} - ${hospital['address']}\nContact: ${hospital['contact']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                ],
              ),
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
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch data from server'),
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
    } catch (e) {
      // Handle network error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital'),
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
                // Specialization Option
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Specialization'),
                      onTap: () => _toggleOption('Specialization'),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                      axisAlignment: -1.0,
                      child: Visibility(
                        visible: _selectedOption == 'Specialization',
                        child: Column(
                          children: _subOptions['Specialization']!.map((subOption) {
                            return ListTile(
                              title: Text(subOption),
                              leading: Radio<String>(
                                value: subOption,
                                groupValue: _selectedSpecialization,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedSpecialization = value;
                                    _selectedOption = ''; // Close options after selection
                                    _animationController.reverse();
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedSpecialization = subOption;
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
