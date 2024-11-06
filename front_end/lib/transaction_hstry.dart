import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006B5F), // Use the deep sea green color
        title: Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white, // Title color to white
            fontSize: 24, // Font size for consistency
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Ensure back icon is white
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Matching padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            _buildBalanceCard(),
            SizedBox(height: 20),
            // Transaction History Title
            Text(
              'Transaction History',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87), // Consistent font style
            ),
            SizedBox(height: 10),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
            _buildTransactionItem('Gazipur - Mohakhali', '- \$10.00', '30 Dec, 10:24 am', Icons.money),
          ],
        ),
      ),
    );
  }

  // Widget for balance card at the top
  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.black],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '1000.00',
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Top Up', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  // Widget for individual transaction items
  Widget _buildTransactionItem(String title, String amount, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
