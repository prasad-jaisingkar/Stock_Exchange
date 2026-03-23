import 'dart:async';
import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/market_data_service.dart';

class StockTile extends StatefulWidget {
  final Stock stock;

  const StockTile({super.key, required this.stock});

  @override
  State<StockTile> createState() => StockTileState();
}

class StockTileState extends State<StockTile> {
  late Stock current;
  StreamSubscription? sub;

  @override
  void initState() {
    super.initState();
    current = widget.stock;
    final key = '${widget.stock.name}_${widget.stock.exchange}';

    sub = MarketDataService.instance.stockPriceStream.listen((updates) {
      final updated = updates[key];
      if (updated == null || !mounted) return;

      setState(() {
        current = current.copyWith(
          price: updated.price,
          change: updated.change,
          changePercent: updated.changePercent,
        );
      });
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  String formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    String result = '';
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        result = ',$result';
      }
      result = intPart[i] + result;
      count++;
    }
    return '$result.$decPart';
  }

  Color priceColor(double change) {
    if (change > 0) return const Color(0xFF1A9E5C);
    if (change < 0) return const Color(0xFFD94040);
    return Colors.grey.shade700;
  }

  String formatChange(double change, double pct) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)} ($sign${pct.toStringAsFixed(2)}%)';
  }

  @override
  Widget build(BuildContext context) {
    final color = priceColor(current.change);
    final label = current.segment.isEmpty
        ? current.exchange
        : '${current.exchange} | ${current.segment}';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 3),
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(current.price),
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 3),
              Text(
                formatChange(current.change, current.changePercent),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
