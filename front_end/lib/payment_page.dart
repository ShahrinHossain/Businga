import 'package:businga1/services/paymentHelper.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String? selected;
  final TextEditingController _amountController = TextEditingController();

  List<Map> gateways = [
    {
      'name': 'SslCommerz',
      'logo':
      'https://apps.odoo.com/web/image/loempia.module/193670/icon_image?unique=c301a64',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'Enter Amount',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount in BDT',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a payment method',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_, index) {
                return PaymentMethodTile(
                  logo: gateways[index]['logo'],
                  name: gateways[index]['name'],
                  selected: selected ?? '',
                  onTap: () {
                    selected = gateways[index]['name']
                        .toString()
                        .replaceAll(' ', '_')
                        .toLowerCase();
                    setState(() {});
                  },
                );
              },
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemCount: gateways.length,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: selected == null
                  ? null
                  : () {
                double amount = double.tryParse(_amountController.text) ?? 0;
                if (amount > 0) {
                  sslcommerz(amount, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selected == null
                      ? Colors.blueAccent.withOpacity(.5)
                      : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Continue to payment',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String logo;
  final String name;
  final Function()? onTap;
  final String selected;

  const PaymentMethodTile({
    super.key,
    required this.logo,
    required this.name,
    this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected == name.replaceAll(' ', '_').toLowerCase()
                ? Colors.blueAccent
                : Colors.black.withOpacity(.1),
            width: 2,
          ),
        ),
        child: ListTile(
          leading: Image.network(logo, height: 35, width: 35),
          title: Text(name),
        ),
      ),
    );
  }
}
