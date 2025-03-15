import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote
            const Text(
              '"Help will always be given at Bussinga to those who ask for it."',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Albussinga Dumbledore, 2025',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            const Text(
              'Whether you are a Passenger, a Bus Driver, or a Bus Owner, Bussinga is here to help with it all. To save time, however, here’s a list of FAQs.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // FAQs
            ExpansionTile(
              title: const Text(
                '1. How Do I Top Up?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'You can top up in several ways, such as SSLCommerz, bKash, Nagad, Rocket, or even a bank account. Online transactions for these services are directly connected to Bussinga and can easily be transferred.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                '2. How Do I Pay?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'You can pay using a QR Code at the stopping destination.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                '3. Is this app really so simple?!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'YES! Bussinga is here to make your life easier.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'For further queries, suggestions, recommendations (or curses), reach us out on:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: bussingaasks@hotmail.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
            const Text(
              'Phone Number: +880175696969',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}