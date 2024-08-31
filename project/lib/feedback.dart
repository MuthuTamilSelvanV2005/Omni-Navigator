import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  final String interactedCategory;

  FeedbackPage({required this.interactedCategory});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with SingleTickerProviderStateMixin {
  String _selectedCategory = '';
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  late final AnimationController _animationController;
  bool _feedbackSubmitted = false;
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Set the initially selected category based on the interacted category
    _selectedCategory = widget.interactedCategory;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = '';
        _animationController.reverse();
      } else {
        _selectedCategory = category;
        _animationController.forward();
      }
    });
  }

  bool _isSubmitEnabled() {
    return _selectedRating > 0 && _feedbackController.text.isNotEmpty;
  }

  void _submitFeedback() {
    if (_isSubmitEnabled()) {
      // Save or send the feedback to the server
      setState(() {
        _feedbackSubmitted = true;
        _showSuccessMessage = true;
      });
    } else if (_selectedCategory.isNotEmpty && (_selectedRating == 0 || _feedbackController.text.isEmpty)) {
      _showFeedbackDialog('Please complete all fields for $_selectedCategory.');
    } else {
      _showFeedbackDialog('Please select a category to provide feedback.');
    }
  }

  void _showFeedbackDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(message),
              SizedBox(height: 16),
              Text('Thank you for your cooperation.', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (_feedbackSubmitted) {
                  _showSuccessScreen(); // Show success screen if feedback was submitted
                } else {
                  _resetForm(); // Reset the form if feedback was not successfully submitted
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessScreen() {
    setState(() {
      _feedbackSubmitted = false;
      _showSuccessMessage = true;
    });

    // Delay for 4-5 seconds before navigating back to the home page
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the first route (HomePage)
    });
  }

  void _resetForm() {
    setState(() {
      _selectedCategory = '';
      _selectedRating = 0;
      _feedbackController.clear();
    });
  }

  void _updateRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  void _updateFeedback(String feedback) {
    setState(() {
      // Rebuild to check if the button should be enabled
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: _showSuccessMessage
          ? Center(
              child: Text(
                'Feedback submitted successfully!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // Housing Category
                      if (widget.interactedCategory == 'Housing') ...[
                        ListTile(
                          title: const Text('Housing'),
                          onTap: () => _toggleCategory('Housing'),
                        ),
                      ],
                      // Restaurant Category
                      if (widget.interactedCategory == 'Restaurant') ...[
                        ListTile(
                          title: const Text('Restaurant'),
                          onTap: () => _toggleCategory('Restaurant'),
                        ),
                      ],
                      // Hospital Category
                      if (widget.interactedCategory == 'Hospital') ...[
                        ListTile(
                          title: const Text('Hospital'),
                          onTap: () => _toggleCategory('Hospital'),
                        ),
                      ],
                      // ATM Category
                      if (widget.interactedCategory == 'ATM') ...[
                        ListTile(
                          title: const Text('ATM'),
                          onTap: () => _toggleCategory('ATM'),
                        ),
                      ],
                      // Shopping Category
                      if (widget.interactedCategory == 'Shopping') ...[
                        ListTile(
                          title: const Text('Shopping'),
                          onTap: () => _toggleCategory('Shopping'),
                        ),
                      ],
                      // If a category is selected, show rating and feedback form
                      if (_selectedCategory.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Rate $_selectedCategory'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < _selectedRating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      _updateRating(index + 1);
                                    },
                                  );
                                }),
                              ),
                              TextField(
                                controller: _feedbackController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Enter your feedback',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: _updateFeedback,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Button centered at the bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: _isSubmitEnabled() ? _submitFeedback : null,
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}


