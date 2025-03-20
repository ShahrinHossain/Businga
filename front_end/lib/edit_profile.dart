/*import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/siam.png'), // Load image from assets
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:  Color(0xFF006B5F),
                      child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Name field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',   // NAMEEEEE
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Sadman Sahil'),
            ),
            SizedBox(height: 20),
            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',  // EMIALLLLL
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'sadubaba@gmail.com'),
            ),
            SizedBox(height: 20),
            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password', // PASSWORRDDD
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '**********'),
            ),
            SizedBox(height: 20),
            // Date of Birth field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',   // DATE OFFF BIRTHHHH
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '23/05/1995'),
            ),
            SizedBox(height: 20),
            // Country/Region field
            TextField(
              decoration: InputDecoration(
                labelText: 'Region',    // REGIIIONNN
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Dhaka'),
            ),
            SizedBox(height: 30),
            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save changes action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color(0xFF006B5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/siam.png'), // Load image from assets
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:  Color(0xFF006B5F),
                      child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Name field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Sadman Sahil'),
            ),
            SizedBox(height: 20),
            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'sadubaba@gmail.com'),
            ),
            SizedBox(height: 20),
            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '**********'),
            ),
            SizedBox(height: 20),
            // Date of Birth field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '23/05/1995'),
            ),
            SizedBox(height: 20),
            // Country/Region field
            TextField(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Dhaka'),
            ),
            SizedBox(height: 30),
            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save changes action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color(0xFF006B5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  // Function to update profile
  Future<void> _updateProfile() async {
    // API endpoint URL
    const String url = 'http://0.0.0.0:8000/api/update_profile/';

    // Prepare the data to send
    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'birthdate': _birthdateController.text,
      'email': _emailController.text,
      'region': _regionController.text,
    };

    try {
      // Send PUT request to the Django backend
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        // Error
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'])),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _birthdateController,
              decoration: const InputDecoration(
                labelText: 'Birthdate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _regionController,
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  // Function to fetch user profile data
  Future<void> _fetchProfileData() async {
    const String url = 'http://127.0.0.1:8000/api/get_profile/'; // Replace with your actual endpoint

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Add the user's token here
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Update the text fields with the fetched data
        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _passwordController.text = '********'; // Mask the password
          _birthdateController.text = data['birthdate'];
          _regionController.text = data['region'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to save changes
  Future<void> _saveChanges() async {
    const String url = 'http://127.0.0.1:8000/api/update_profile/'; // Replace with your actual endpoint

    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'birthdate': _birthdateController.text,
      'region': _regionController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Add the user's token here
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch profile data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/siam.png'), // Load image from assets
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:  Color(0xFF006B5F),
                      child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Name field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: _nameController,
            ),
            SizedBox(height: 20),
            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: _emailController,
            ),
            SizedBox(height: 20),
            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: _passwordController,
            ),
            SizedBox(height: 20),
            // Date of Birth field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: _birthdateController,
            ),
            SizedBox(height: 20),
            // Country/Region field
            TextField(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: _regionController,
            ),
            SizedBox(height: 30),
            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color(0xFF006B5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final String authToken; // Pass the authentication token when navigating to this page
  const EditProfilePage({super.key, required this.authToken});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  // Flags to toggle edit mode
  bool _isNameEditable = false;
  bool _isEmailEditable = false;
  bool _isPasswordEditable = false;
  bool _isBirthdateEditable = false;
  bool _isRegionEditable = false;

  // Function to fetch user profile data
  Future<void> _fetchProfileData() async {
    const String url = 'http://0.0.0.0:8000/api/get_profile/'; // Django backend endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}', // Use the passed token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Update the text fields with the fetched data
        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _passwordController.text = '********'; // Mask the password
          _birthdateController.text = data['birthdate'];
          _regionController.text = data['region'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to save changes
  Future<void> _saveChanges() async {
    const String url = 'http://0.0.0.0:8000/api/update_profile/'; // Django backend endpoint

    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'birthdate': _birthdateController.text,
      'region': _regionController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.authToken}', // Use the passed token
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch profile data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/siam.png'), // Load image from assets
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:  Color(0xFF006B5F),
                      child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Name field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    controller: _nameController,
                    enabled: _isNameEditable,
                  ),
                ),
                IconButton(
                  icon: Icon(_isNameEditable ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isNameEditable = !_isNameEditable;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Email field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    controller: _emailController,
                    enabled: _isEmailEditable,
                  ),
                ),
                IconButton(
                  icon: Icon(_isEmailEditable ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEmailEditable = !_isEmailEditable;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Password field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    controller: _passwordController,
                    enabled: _isPasswordEditable,
                  ),
                ),
                IconButton(
                  icon: Icon(_isPasswordEditable ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isPasswordEditable = !_isPasswordEditable;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Date of Birth field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    controller: _birthdateController,
                    enabled: _isBirthdateEditable,
                  ),
                ),
                IconButton(
                  icon: Icon(_isBirthdateEditable ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isBirthdateEditable = !_isBirthdateEditable;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Country/Region field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Region',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    controller: _regionController,
                    enabled: _isRegionEditable,
                  ),
                ),
                IconButton(
                  icon: Icon(_isRegionEditable ? Icons.save : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isRegionEditable = !_isRegionEditable;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color(0xFF006B5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


