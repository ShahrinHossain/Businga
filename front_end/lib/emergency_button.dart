import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyButton extends StatelessWidget {
  final String busOwnerPhoneNumber;
  final String policeStationPhoneNumber;

  const EmergencyButton({
    Key? key,
    required this.busOwnerPhoneNumber,
    required this.policeStationPhoneNumber,
  }) : super(key: key);

  Future<void> _sendSMS(String phoneNumber, String message, BuildContext context) async {
    final Uri smsUri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message)}");

    if (!await launchUrl(smsUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not send SMS to $phoneNumber")),
      );
    }
  }

  Future<void> _handleEmergency(BuildContext context) async {
    final String emergencyMessage = "EMERGENCY! Please help! Bus is in danger.";

    try {
      await _sendSMS(busOwnerPhoneNumber, emergencyMessage, context);
      await _sendSMS(policeStationPhoneNumber, emergencyMessage, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _handleEmergency(context),
      backgroundColor: Colors.red,
      child: const Icon(Icons.warning, size: 30, color: Colors.white),
    );
  }
}
