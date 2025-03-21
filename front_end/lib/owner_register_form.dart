import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'login_page.dart'; // Import your login page

class OwnerRegisterForm extends StatefulWidget {
  @override
  _OwnerRegisterFormState createState() => _OwnerRegisterFormState();
}

class _OwnerRegisterFormState extends State<OwnerRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessRegController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _brtaCertController = TextEditingController();

  String? brtaCertificateFile;
  String? nationalIdFile;
  String? businessRegFile;

  Future<void> _pickFile(Function(String) onFileSelected) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      onFileSelected(result.files.single.path!);
    }
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request is sent to admin! We will get back to you soon.')),
      );

      // Navigate back to the login page after a short delay
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {  },)), // Replace with your login page widget
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                // Email Address
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email Address'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                // Residential Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Residential Address'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                // National ID / Passport Number
                TextFormField(
                  controller: _nationalIdController,
                  decoration: InputDecoration(labelText: 'National ID / Passport Number'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 20),

                // Business Name
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(labelText: 'Business Name (if applicable)'),
                ),

                // Business Registration Number
                TextFormField(
                  controller: _businessRegController,
                  decoration: InputDecoration(labelText: 'Business Registration Number'),
                ),

                // TIN / GST Number
                TextFormField(
                  controller: _taxIdController,
                  decoration: InputDecoration(labelText: 'TIN / GST Number'),
                ),

                SizedBox(height: 20),

                // BRTA Certificate Number
                TextFormField(
                  controller: _brtaCertController,
                  decoration: InputDecoration(labelText: 'BRTA Certificate Number'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 20),

                // BRTA Certificate Upload
                ElevatedButton(
                  onPressed: () => _pickFile((path) => setState(() => brtaCertificateFile = path)),
                  child: Text('Upload BRTA Certificate'),
                ),
                if (brtaCertificateFile != null)
                  Text(
                    'Selected File: ${brtaCertificateFile!.split('/').last}',
                    style: TextStyle(color: Colors.green),
                  ),

                // National ID / Passport Upload
                ElevatedButton(
                  onPressed: () => _pickFile((path) => setState(() => nationalIdFile = path)),
                  child: Text('Upload National ID / Passport'),
                ),
                if (nationalIdFile != null)
                  Text(
                    'Selected File: ${nationalIdFile!.split('/').last}',
                    style: TextStyle(color: Colors.green),
                  ),

                // Business Registration Certificate Upload
                ElevatedButton(
                  onPressed: () => _pickFile((path) => setState(() => businessRegFile = path)),
                  child: Text('Upload Business Registration Certificate'),
                ),
                if (businessRegFile != null)
                  Text(
                    'Selected File: ${businessRegFile!.split('/').last}',
                    style: TextStyle(color: Colors.green),
                  ),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}