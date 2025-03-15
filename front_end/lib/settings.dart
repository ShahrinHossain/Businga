/*import 'package:flutter/material.dart';

import 'edit_profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006B5F), // Deep sea green background color
        iconTheme: IconThemeData(color: Colors.white), // White arrow icon color
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color for the title
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow icon
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
              _buildSettingsOption(context, Icons.person, 'Edit profile', EditProfilePage()),
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
        ...options, // Display all options under the section
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
          MaterialPageRoute(builder: (context) => page), // Navigate to the provided page
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
}*/


/*import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'terms_and_policies.dart';

// Define placeholder pages for each option
class TermsAndPoliciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Policies'),
      ),
      body: Center(
        child: Text('Terms and Policies Page'),
      ),
    );
  }
}

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Center(
        child: Text('Help & Support Page'),
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy'),
      ),
      body: Center(
        child: Text('Privacy Page'),
      ),
    );
  }
}

class ReportProblemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Problem'),
      ),
      body: Center(
        child: Text('Report a Problem Page'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006B5F),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(context, 'Account', [
              _buildSettingsOption(context, Icons.person, 'Edit profile', EditProfilePage()),
              _buildSettingsOption(context, Icons.security, 'Security', null),
              _buildSettingsOption(context, Icons.notifications, 'Notifications', null),
              _buildSettingsOption(context, Icons.privacy_tip, 'Privacy', PrivacyPage()),
            ]),
            _buildSettingsSection(context, 'Support & About', [
              _buildSettingsOption(context, Icons.help_outline, 'Help & Support', HelpAndSupportPage()),
              _buildSettingsOption(context, Icons.policy, 'Terms and Policies', TermsAndPoliciesPage()),
            ]),
            _buildSettingsSection(context, 'Actions', [
              _buildSettingsOption(context, Icons.report, 'Report a problem', ReportProblemPage()),
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
        ...options,
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
                MaterialPageRoute(builder: (context) => page),
              );
            }
          : null,
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
}*/

import 'package:flutter/material.dart';
import 'edit_profile.dart'; // Assuming this is used
import 'terms_and_policies.dart'; // Import the terms and policies page
import 'help_and_support.dart';
import 'privacy.dart';
import 'notifications.dart';
import 'security.dart';
import 'report_problem.dart';
import 'log_out.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006B5F),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(context, 'Account', [
              _buildSettingsOption(
                context,
                Icons.person,
                'Edit profile',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              _buildSettingsOption(context, Icons.security, 'Security', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SecurityPage()),
                );
              }),
              _buildSettingsOption(context, Icons.notifications, 'Notifications', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              }),
              _buildSettingsOption(context, Icons.privacy_tip, 'Privacy', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacyPage()),
                );
              }),
            ]),
            _buildSettingsSection(context, 'Support & About', [
              _buildSettingsOption(context, Icons.help_outline, 'Help & Support', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpAndSupport()),
                );
              }),
              _buildSettingsOption(
                context,
                Icons.policy,
                'Terms and Policies',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TermsAndPoliciesPage()),
                  );
                },
              ),
            ]),
            _buildSettingsSection(context, 'Actions', [
              _buildSettingsOption(context, Icons.report, 'Report a problem', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReportProblemPage()),
                );
              }),
              //_buildSettingsOption(context, Icons.add, 'Add account', onTap: () {}),
              _buildSettingsOption(context, Icons.logout, 'Log out', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LogOutPage()),
                );
              }),
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
        ...options, // Display all options under the section
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper to build each settings option
  Widget _buildSettingsOption(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap callback
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

