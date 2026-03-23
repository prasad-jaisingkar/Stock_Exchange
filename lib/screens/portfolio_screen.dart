import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  final List<Map<String, dynamic>> holdings = const [
    {'name': 'RELIANCE', 'qty': 10, 'avg': 1340.00, 'ltp': 1374.00, 'pnl': 340.00, 'pnlPct': 2.54},
    {'name': 'HDFCBANK', 'qty': 20, 'avg': 950.00, 'ltp': 966.85, 'pnl': 337.00, 'pnlPct': 1.77},
    {'name': 'MRF', 'qty': 1, 'avg': 145000.00, 'ltp': 147625.00, 'pnl': 2625.00, 'pnlPct': 1.81},
    {'name': 'TCS', 'qty': 5, 'avg': 3700.00, 'ltp': 3845.60, 'pnl': 728.00, 'pnlPct': 3.93},
  ];

  @override
  Widget build(BuildContext context) {
    double totalInvested = holdings.fold(0, (sum, h) => sum + h['avg'] * h['qty']);
    double totalPnl = holdings.fold(0, (sum, h) => sum + (h['pnl'] as double) * (h['qty'] as int));
    double totalPnlPct = (totalPnl / totalInvested) * 100;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Portfolio',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                Expanded(child: summaryTile('Invested', '₹${totalInvested.toStringAsFixed(0)}')),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: summaryTile(
                    'P&L',
                    '₹${totalPnl.toStringAsFixed(0)}',
                    valueColor: totalPnl >= 0 ? const Color(0xFF1A9E5C) : const Color(0xFFD94040),
                    subtitle: '${totalPnlPct >= 0 ? '+' : ''}${totalPnlPct.toStringAsFixed(2)}%',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: holdings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final h = holdings[index];
                final pnl = (h['pnl'] as double) * (h['qty'] as int);
                final isGain = pnl >= 0;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(h['name'],
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('Qty: ${h['qty']}  Avg: ₹${h['avg']}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('₹${(h['ltp'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          '${isGain ? '+' : ''}₹${pnl.toStringAsFixed(0)} (${isGain ? '+' : ''}${h['pnlPct']}%)',
                          style: TextStyle(
                              fontSize: 11,
                              color: isGain ? const Color(0xFF1A9E5C) : const Color(0xFFD94040)),
                        ),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryTile(String label, String value, {Color? valueColor, String? subtitle}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: valueColor ?? Colors.black87)),
        if (subtitle != null)
          Text(subtitle, style: TextStyle(fontSize: 11, color: valueColor ?? Colors.grey)),
      ],
    );
  }
}
