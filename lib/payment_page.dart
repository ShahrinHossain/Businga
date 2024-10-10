import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedMethod;
  final TextEditingController _amountController = TextEditingController();

  // Function to handle payment method selection
  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        elevation: 0,
        title: Text(
          'Top Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPaymentOption('via BKash', Icons.phone_android),
            _buildPaymentOption('via Card', Icons.credit_card),
            _buildPaymentOption('via Nagad', Icons.phone_android),
            SizedBox(height: 30),
            Text(
              'Enter Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount in BDT',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle the top-up process here
                _performTopUp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Confirm Top-Up',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build a payment option button
  Widget _buildPaymentOption(String method, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.teal),
      title: Text(
        method,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Radio<String>(
        value: method,
        groupValue: _selectedMethod,
        onChanged: (String? value) {
          _selectPaymentMethod(value!);
        },
      ),
      onTap: () => _selectPaymentMethod(method),
    );
  }

  // Function to handle the top-up logic
  void _performTopUp() {
    final amount = _amountController.text;
    if (_selectedMethod != null && amount.isNotEmpty) {
      // Implement the top-up process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top-up via $_selectedMethod for $amount BDT')),
      );
    } else {
      // Show an error message if no method or amount is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a payment method and enter an amount')),
      );
    }
  }
}
