import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Account Security'),
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
            _buildSettingsOption(
              context,
              Icons.password,
              'Update Security Questions',
              onTap: () {
                // Navigate to update security questions
                _showUpdateSecurityQuestions(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Device Security'),
            _buildSettingsOption(
              context,
              Icons.phone_android,
              'Manage Trusted Devices',
              onTap: () {
                // Navigate to manage trusted devices
                _showManageTrustedDevices(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.fingerprint,
              'Biometric Authentication',
              onTap: () {
                // Navigate to biometric authentication settings
                _showBiometricAuthenticationSettings(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Session Management'),
            _buildSettingsOption(
              context,
              Icons.devices,
              'Active Sessions',
              onTap: () {
                // Navigate to view active sessions
                _showActiveSessions(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.logout,
              'Log Out of All Devices',
              onTap: () {
                // Log out of all devices
                _logOutOfAllDevices(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Advanced Security'),
            _buildSettingsOption(
              context,
              Icons.verified_user,
              'Enable Advanced Encryption',
              onTap: () {
                // Enable advanced encryption
                _enableAdvancedEncryption(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.security_update,
              'Check for Security Updates',
              onTap: () {
                // Check for security updates
                _checkForSecurityUpdates(context);
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

  void _showUpdateSecurityQuestions(BuildContext context) {
    // Navigate to update security questions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Update Security Questions')),
    );
  }

  void _showManageTrustedDevices(BuildContext context) {
    // Navigate to manage trusted devices
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Manage Trusted Devices')),
    );
  }

  void _showBiometricAuthenticationSettings(BuildContext context) {
    // Navigate to biometric authentication settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Biometric Authentication Settings')),
    );
  }

  void _showActiveSessions(BuildContext context) {
    // Navigate to view active sessions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Active Sessions')),
    );
  }

  void _logOutOfAllDevices(BuildContext context) {
    // Log out of all devices
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out of all devices')),
    );
  }

  void _enableAdvancedEncryption(BuildContext context) {
    // Enable advanced encryption
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced Encryption Enabled')),
    );
  }

  void _checkForSecurityUpdates(BuildContext context) {
    // Check for security updates
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking for Security Updates...')),
    );
  }
}