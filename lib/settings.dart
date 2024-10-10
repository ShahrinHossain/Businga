import 'package:flutter/material.dart';

import 'edit_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(context, 'Account', [
              _buildSettingsOption(context, Icons.person, 'Edit profile', EditProfilePage()),  // Navigate to EditProfilePage
              _buildSettingsOption(context, Icons.security, 'Security', null),
              _buildSettingsOption(context, Icons.notifications, 'Notifications', null),
              _buildSettingsOption(context, Icons.privacy_tip, 'Privacy', null),
            ]),
            _buildSettingsSection(context, 'Support & About', [
              _buildSettingsOption(context, Icons.help_outline, 'Help & Support', null),
              _buildSettingsOption(context, Icons.policy, 'Terms and Policies', null),
            ]),
            _buildSettingsSection(context, 'Actions', [
              _buildSettingsOption(context, Icons.report, 'Report a problem', null),
              _buildSettingsOption(context, Icons.add, 'Add account', null),
              _buildSettingsOption(context, Icons.logout, 'Log out', null),
            ]),
          ],
        ),
      ),
    );
  }

  // Helper to build each section title
  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        ...options,  // Display all options under the section
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper to build each settings option
  Widget _buildSettingsOption(BuildContext context, IconData icon, String label, Widget? page) {
    return GestureDetector(
      onTap: page != null
          ? () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),  // Navigate to the provided page
        );
      }
          : null, // No action if no page provided
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey),
            const SizedBox(width: 15),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
