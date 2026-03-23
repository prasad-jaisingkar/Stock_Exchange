import 'package:flutter/material.dart';

class FundsScreen extends StatelessWidget {
  const FundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Funds', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            balanceCard(),
            const SizedBox(height: 16),
            actionButtons(context),
            const SizedBox(height: 16),
            marginBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget balanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Balance', style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          const SizedBox(height: 8),
          const Text('₹1,25,430.00',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cardLabel('Used Margin', '₹32,560'),
              cardLabel('Total Balance', '₹1,57,990'),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }

  Widget actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Add funds flow coming soon'))),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: const Text('+ Add Funds',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Withdraw flow coming soon'))),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Withdraw',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget marginBreakdown() {
    final rows = [
      {'label': 'Opening Balance', 'value': '₹1,57,990.00'},
      {'label': 'Payin', 'value': '₹0.00'},
      {'label': 'SPAN Margin', 'value': '-₹12,340.00'},
      {'label': 'Exposure Margin', 'value': '-₹8,220.00'},
      {'label': 'MTM Loss', 'value': '-₹12,000.00'},
      {'label': 'Available Cash', 'value': '₹1,25,430.00'},
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.value['label']!,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    Text(
                      entry.value['value']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isLast ? FontWeight.w700 : FontWeight.w400,
                        color: isLast ? Colors.black : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
