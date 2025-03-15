import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Location Settings'),
            _buildSettingsOption(
              context,
              Icons.location_on,
              'Manage Location Access',
              onTap: () {
                // Navigate to location settings
                _showLocationSettings(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.delete,
              'Clear Location History',
              onTap: () {
                // Clear location history
                _clearLocationHistory(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Data Sharing'),
            _buildSettingsOption(
              context,
              Icons.share,
              'Control Data Sharing with Third Parties',
              onTap: () {
                // Navigate to data sharing settings
                _showDataSharingSettings(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.ads_click,
              'Ad Personalization',
              onTap: () {
                // Navigate to ad personalization settings
                _showAdPersonalizationSettings(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Ride History'),
            _buildSettingsOption(
              context,
              Icons.history,
              'View Ride History',
              onTap: () {
                // Navigate to ride history
                _showRideHistory(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.delete_forever,
              'Delete Ride History',
              onTap: () {
                // Delete ride history
                _deleteRideHistory(context);
              },
            ),
            const SizedBox(height: 20),

            /*_buildSectionTitle('Communication Preferences'),
            _buildSettingsOption(
              context,
              Icons.notifications,
              'Manage Notifications',
              onTap: () {
                // Navigate to notification settings
                _showNotificationSettings(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.email,
              'Email Preferences',
              onTap: () {
                // Navigate to email preferences
                _showEmailPreferences(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Security'),
            _buildSettingsOption(
              context,
              Icons.security,
              'Two-Factor Authentication',
              onTap: () {
                // Navigate to 2FA settings
                _showTwoFactorAuthSettings(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.lock,
              'Change Password',
              onTap: () {
                // Navigate to change password
                _showChangePassword(context);
              },
            ),
            const SizedBox(height: 20),
            */
            _buildSectionTitle('Legal'),
            _buildSettingsOption(
              context,
              Icons.privacy_tip,
              'View Privacy Policy',
              onTap: () {
                // Navigate to privacy policy
                _showPrivacyPolicy(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.description,
              'View Terms of Service',
              onTap: () {
                // Navigate to terms of service
                _showTermsOfService(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper to build settings options
  Widget _buildSettingsOption(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
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

  // Placeholder functions for navigation or actions
  void _showLocationSettings(BuildContext context) {
    // Navigate to location settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Location Settings')),
    );
  }

  void _clearLocationHistory(BuildContext context) {
    // Clear location history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location history cleared')),
    );
  }

  void _showDataSharingSettings(BuildContext context) {
    // Navigate to data sharing settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Data Sharing Settings')),
    );
  }

  void _showAdPersonalizationSettings(BuildContext context) {
    // Navigate to ad personalization settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Ad Personalization Settings')),
    );
  }

  void _showRideHistory(BuildContext context) {
    // Navigate to ride history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Ride History')),
    );
  }

  void _deleteRideHistory(BuildContext context) {
    // Delete ride history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride history deleted')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Navigate to notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Notification Settings')),
    );
  }

  void _showEmailPreferences(BuildContext context) {
    // Navigate to email preferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Email Preferences')),
    );
  }

  void _showTwoFactorAuthSettings(BuildContext context) {
    // Navigate to 2FA settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Two-Factor Authentication Settings')),
    );
  }

  void _showChangePassword(BuildContext context) {
    // Navigate to change password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Change Password')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    // Navigate to privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Privacy Policy')),
    );
  }

  void _showTermsOfService(BuildContext context) {
    // Navigate to terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Terms of Service')),
    );
  }
}