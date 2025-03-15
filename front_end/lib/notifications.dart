import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // State variables for each switch
  bool _rideStatusNotifications = true;
  bool _driverNotifications = false;
  bool _promotionalNotifications = true;
  bool _partnerOffers = false;
  bool _safetyNotifications = true;
  bool _emergencyAlerts = true;
  bool _paymentNotifications = true;
  bool _accountUpdates = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Ride Updates'),
            _buildNotificationOption(
              context,
              'Ride Status Notifications',
              'Get real-time updates about your ride status.',
              value: _rideStatusNotifications,
              onChanged: (bool value) {
                setState(() {
                  _rideStatusNotifications = value;
                });
                _handleRideStatusNotifications(value);
              },
            ),
            _buildNotificationOption(
              context,
              'Driver Notifications',
              'Receive notifications when your driver is nearby.',
              value: _driverNotifications,
              onChanged: (bool value) {
                setState(() {
                  _driverNotifications = value;
                });
                _handleDriverNotifications(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Promotions and Offers'),
            _buildNotificationOption(
              context,
              'Promotional Notifications',
              'Receive notifications about promotions and discounts.',
              value: _promotionalNotifications,
              onChanged: (bool value) {
                setState(() {
                  _promotionalNotifications = value;
                });
                _handlePromotionalNotifications(value);
              },
            ),
            _buildNotificationOption(
              context,
              'Partner Offers',
              'Get notifications about offers from our partners.',
              value: _partnerOffers,
              onChanged: (bool value) {
                setState(() {
                  _partnerOffers = value;
                });
                _handlePartnerOffers(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Safety Alerts'),
            _buildNotificationOption(
              context,
              'Safety Notifications',
              'Receive important safety alerts during your ride.',
              value: _safetyNotifications,
              onChanged: (bool value) {
                setState(() {
                  _safetyNotifications = value;
                });
                _handleSafetyNotifications(value);
              },
            ),
            _buildNotificationOption(
              context,
              'Emergency Alerts',
              'Get notifications in case of emergencies.',
              value: _emergencyAlerts,
              onChanged: (bool value) {
                setState(() {
                  _emergencyAlerts = value;
                });
                _handleEmergencyAlerts(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Account and Payments'),
            _buildNotificationOption(
              context,
              'Payment Notifications',
              'Receive notifications about payment updates.',
              value: _paymentNotifications,
              onChanged: (bool value) {
                setState(() {
                  _paymentNotifications = value;
                });
                _handlePaymentNotifications(value);
              },
            ),
            _buildNotificationOption(
              context,
              'Account Updates',
              'Get notifications about changes to your account.',
              value: _accountUpdates,
              onChanged: (bool value) {
                setState(() {
                  _accountUpdates = value;
                });
                _handleAccountUpdates(value);
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Preferences'),
            _buildNotificationOption(
              context,
              'Email Notifications',
              'Receive notifications via email.',
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
                _handleEmailNotifications(value);
              },
            ),
            _buildNotificationOption(
              context,
              'SMS Notifications',
              'Receive notifications via SMS.',
              value: _smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  _smsNotifications = value;
                });
                _handleSmsNotifications(value);
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

  // Helper to build notification options with a switch
  Widget _buildNotificationOption(
      BuildContext context,
      String title,
      String description, {
        required bool value,
        required Function(bool) onChanged,
      }) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // Placeholder functions for handling notification toggles
  void _handleRideStatusNotifications(bool value) {
    // Handle ride status notifications
    print('Ride Status Notifications: $value');
  }

  void _handleDriverNotifications(bool value) {
    // Handle driver notifications
    print('Driver Notifications: $value');
  }

  void _handlePromotionalNotifications(bool value) {
    // Handle promotional notifications
    print('Promotional Notifications: $value');
  }

  void _handlePartnerOffers(bool value) {
    // Handle partner offers
    print('Partner Offers: $value');
  }

  void _handleSafetyNotifications(bool value) {
    // Handle safety notifications
    print('Safety Notifications: $value');
  }

  void _handleEmergencyAlerts(bool value) {
    // Handle emergency alerts
    print('Emergency Alerts: $value');
  }

  void _handlePaymentNotifications(bool value) {
    // Handle payment notifications
    print('Payment Notifications: $value');
  }

  void _handleAccountUpdates(bool value) {
    // Handle account updates
    print('Account Updates: $value');
  }

  void _handleEmailNotifications(bool value) {
    // Handle email notifications
    print('Email Notifications: $value');
  }

  void _handleSmsNotifications(bool value) {
    // Handle SMS notifications
    print('SMS Notifications: $value');
  }
}