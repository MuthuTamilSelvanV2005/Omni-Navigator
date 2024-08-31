import 'package:flutter/material.dart';
import 'package:project/housing.dart';
import 'package:project/restaurant.dart';
import 'package:project/hospital.dart';
import 'package:project/atm.dart';
import 'package:project/shopping.dart';  // Import the ShoppingPage
import 'package:project/feedback.dart';  // Import the FeedbackPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _interactedCategory = ''; // Track the interacted category

  static List<Widget> _pages = <Widget>[
    HousingPage(),
    RestaurantPage(),
    HospitalPage(),
    ATMPage(),
    ShoppingPage(),
    Container(), // Placeholder for FeedbackPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Set interacted category based on the selected page
      switch (index) {
        case 0:
          _interactedCategory = 'Housing';
          break;
        case 1:
          _interactedCategory = 'Restaurant';
          break;
        case 2:
          _interactedCategory = 'Hospital';
          break;
        case 3:
          _interactedCategory = 'ATM';
          break;
        case 4:
          _interactedCategory = 'Shopping';
          break;
        case 5:
          // Prepare FeedbackPage with the selected category
          _pages[5] = FeedbackPage(interactedCategory: _interactedCategory);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Domain'),
        backgroundColor: Colors.blue, // Set AppBar color to blue
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Housing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Hospital',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.atm),
            label: 'ATM',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(  // Add Feedback icon and label
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,  // Blue color for selected item
        unselectedItemColor: Colors.blue[600], // Slightly darker blue for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
