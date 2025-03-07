import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../globalVariables.dart';
import '../paymentSuccessful.dart';

var baseUrl = getIp();

void onButtonTap(String selected, double amount, BuildContext context) async {
  switch (selected) {
    case 'sslcommerz':
      sslcommerz(amount, context); // Pass context to sslcommerz
      break;
    default:
      print('No gateway selected');
  }
}
double totalPrice = 1.00;

/// SslCommerz
void sslcommerz(double amount, BuildContext context) async {
  Sslcommerz sslcommerz = Sslcommerz(
    initializer: SSLCommerzInitialization(
      multi_card_name: "visa,master,bkash",
      currency: SSLCurrencyType.BDT,
      product_category: "Digital Product",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: "bussi67ca47e24929e",
      store_passwd: "bussi67ca47e24929e@ssl",
      total_amount: amount,
      tran_id: "TestTRX001",
    ),
  );

  final response = await sslcommerz.payNow();

  if (response.status == 'VALID') {
    print(jsonEncode(response));

    // Send the successful payment info to the API
    print('Payment completed, TRX ID: ${response.tranId}');
    print(response.tranDate);

    // Call the API to update the user's balance
    await makePaymentRequest(amount);

    // Navigate to the PaymentSuccessful screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessful(amount: amount),
      ),
    );
  }

  if (response.status == 'Closed') {
    print('Payment closed');
  }

  if (response.status == 'FAILED') {
    print('Payment failed');
  }
}


/// Function to make an API request to /users/make-payment/
Future<void> makePaymentRequest(double amount) async {
  String? token = await getAuthToken();
  if (token == null) {
    print('User is not logged in');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/users/make-payment/'), // Replace with actual API URL
      headers: {
        'Authorization': 'Bearer $token', // Add token in Authorization header
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Payment successfully recorded');
    } else {
      // Handle failure
      print('Failed to record payment: ${response.body}');
    }
  } catch (e) {
    print('An error occurred while making the payment request: $e');
  }
}

/// Function to get the stored JWT token from SharedPreferences
Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token'); // Get the stored token
}
