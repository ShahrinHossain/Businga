import 'package:flutter/material.dart';

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Problem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Common Issues'),
            _buildSettingsOption(
              context,
              Icons.report_problem,
              'Report a Ride Issue',
              onTap: () {
                // Navigate to report a ride issue
                _showReportRideIssue(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.payment,
              'Report a Payment Issue',
              onTap: () {
                // Navigate to report a payment issue
                _showReportPaymentIssue(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.person,
              'Report a Driver Issue',
              onTap: () {
                // Navigate to report a driver issue
                _showReportDriverIssue(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Feedback and Suggestions'),
            _buildSettingsOption(
              context,
              Icons.feedback,
              'Provide Feedback',
              onTap: () {
                // Navigate to provide feedback
                _showProvideFeedback(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.lightbulb,
              'Suggest a Feature',
              onTap: () {
                // Navigate to suggest a feature
                _showSuggestFeature(context);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Contact Support'),
            _buildSettingsOption(
              context,
              Icons.help,
              'Help Center',
              onTap: () {
                // Navigate to help center
                _showHelpCenter(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.email,
              'Email Support',
              onTap: () {
                // Navigate to email support
                _showEmailSupport(context);
              },
            ),
            _buildSettingsOption(
              context,
              Icons.chat,
              'Live Chat',
              onTap: () {
                // Navigate to live chat
                _showLiveChat(context);
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
  void _showReportRideIssue(BuildContext context) {
    // Navigate to report a ride issue
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Report a Ride Issue')),
    );
  }

  void _showReportPaymentIssue(BuildContext context) {
    // Navigate to report a payment issue
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Report a Payment Issue')),
    );
  }

  void _showReportDriverIssue(BuildContext context) {
    // Navigate to report a driver issue
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Report a Driver Issue')),
    );
  }

  void _showProvideFeedback(BuildContext context) {
    // Navigate to provide feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Provide Feedback')),
    );
  }

  void _showSuggestFeature(BuildContext context) {
    // Navigate to suggest a feature
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Suggest a Feature')),
    );
  }

  void _showHelpCenter(BuildContext context) {
    // Navigate to help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Help Center')),
    );
  }

  void _showEmailSupport(BuildContext context) {
    // Navigate to email support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Email Support')),
    );
  }

  void _showLiveChat(BuildContext context) {
    // Navigate to live chat
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Live Chat')),
    );
  }
}