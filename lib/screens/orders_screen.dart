import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Orders', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [Tab(text: 'Pending'), Tab(text: 'Executed'), Tab(text: 'Cancelled')],
          ),
        ),
        body: TabBarView(
          children: [
            buildEmptyState('No pending orders', Icons.hourglass_empty_outlined),
            buildEmptyState('No executed orders', Icons.check_circle_outline),
            buildEmptyState('No cancelled orders', Icons.cancel_outlined),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 8),
          Text('Your orders will appear here', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      ),
    );
  }
}
