import 'package:flutter/material.dart';
import '../models/stock.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  String query = '';

  final List<Stock> allStocks = [
    Stock(name: 'RELIANCE', exchange: 'NSE', segment: 'EQ', price: 1374.00, change: -4.50, changePercent: -0.33),
    Stock(name: 'HDFCBANK', exchange: 'NSE', segment: 'EQ', price: 966.85, change: 0.85, changePercent: 0.09),
    Stock(name: 'ASIANPAINT', exchange: 'NSE', segment: 'EQ', price: 2537.40, change: 6.60, changePercent: 0.26),
    Stock(name: 'NIFTY IT', exchange: 'IDX', segment: '', price: 35187.55, change: 877.11, changePercent: 2.56),
    Stock(name: 'MRF', exchange: 'NSE', segment: 'EQ', price: 147625.00, change: 550.00, changePercent: 0.37),
    Stock(name: 'TCS', exchange: 'NSE', segment: 'EQ', price: 3845.60, change: 45.20, changePercent: 1.19),
    Stock(name: 'INFY', exchange: 'NSE', segment: 'EQ', price: 1432.75, change: -12.30, changePercent: -0.85),
    Stock(name: 'WIPRO', exchange: 'NSE', segment: 'EQ', price: 456.80, change: 3.40, changePercent: 0.75),
    Stock(name: 'HCLTECH', exchange: 'NSE', segment: 'EQ', price: 1267.90, change: 18.60, changePercent: 1.49),
    Stock(name: 'TECHM', exchange: 'NSE', segment: 'EQ', price: 1198.45, change: -8.75, changePercent: -0.72),
    Stock(name: 'TATASTEEL', exchange: 'NSE', segment: 'EQ', price: 134.20, change: 2.10, changePercent: 1.59),
    Stock(name: 'JSWSTEEL', exchange: 'NSE', segment: 'EQ', price: 867.35, change: -5.65, changePercent: -0.65),
    Stock(name: 'HINDALCO', exchange: 'NSE', segment: 'EQ', price: 578.90, change: 7.80, changePercent: 1.37),
    Stock(name: 'COALINDIA', exchange: 'NSE', segment: 'EQ', price: 432.55, change: -3.20, changePercent: -0.73),
    Stock(name: 'ICICIBANK', exchange: 'NSE', segment: 'EQ', price: 1102.40, change: 14.30, changePercent: 1.31),
    Stock(name: 'SBIN', exchange: 'NSE', segment: 'EQ', price: 812.65, change: -6.40, changePercent: -0.78),
    Stock(name: 'BAJFINANCE', exchange: 'NSE', segment: 'EQ', price: 6834.20, change: 88.50, changePercent: 1.31),
    Stock(name: 'AXISBANK', exchange: 'NSE', segment: 'EQ', price: 1178.90, change: 9.20, changePercent: 0.79),
    Stock(name: 'KOTAKBANK', exchange: 'NSE', segment: 'EQ', price: 1756.35, change: -18.40, changePercent: -1.04),
    Stock(name: 'NIFTY 50', exchange: 'IDX', segment: '', price: 22456.80, change: 134.60, changePercent: 0.60),
  ];

  List<Stock> get filtered {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toUpperCase();
    return allStocks.where((s) => s.name.contains(q) || s.exchange.contains(q)).toList();
  }

  Color changeColor(double change) {
    if (change > 0) return const Color(0xFF1A9E5C);
    if (change < 0) return const Color(0xFFD94040);
    return Colors.grey;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filtered;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search for instruments',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          onChanged: (val) => setState(() => query = val),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade600),
              onPressed: () {
                controller.clear();
                setState(() => query = '');
              },
            ),
        ],
      ),
      body: query.isEmpty
          ? buildRecentSearches()
          : results.isEmpty
              ? buildNoResults()
              : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final stock = results[index];
                    final label = stock.segment.isEmpty
                        ? stock.exchange
                        : '${stock.exchange} | ${stock.segment}';
                    final color = changeColor(stock.change);
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(stock.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                            const SizedBox(height: 3),
                            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(
                              stock.price.toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(2)} (${stock.changePercent.toStringAsFixed(2)}%)',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                          ]),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget buildRecentSearches() {
    final recents = ['RELIANCE', 'HDFCBANK', 'NIFTY 50', 'TCS'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Recent Searches', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: recents.map((name) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      controller.text = name;
                      setState(() => query = name);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: Row(
                        children: [
                          Icon(Icons.history, size: 16, color: Colors.grey.shade400),
                          const SizedBox(width: 12),
                          Text(name, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100, indent: 44),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No results for "$query"', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
          const SizedBox(height: 8),
          Text('Try searching with a different symbol', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      ),
    );
  }
}
