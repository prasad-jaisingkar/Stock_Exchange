import 'package:flutter/material.dart';

class GttScreen extends StatelessWidget {
  const GttScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('GTT+', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [Tab(text: 'Active'), Tab(text: 'Triggered')],
          ),
        ),
        body: TabBarView(
          children: [
            buildEmptyState('No active GTT orders', 'Set trigger-based orders that execute automatically'),
            buildEmptyState('No triggered orders', 'Triggered GTT orders will appear here'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New GTT', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bolt_outlined, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
