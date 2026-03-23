import 'dart:async';
import 'package:flutter/material.dart';
import '../models/index_quote.dart';
import '../services/market_data_service.dart';

class MarketHeader extends StatefulWidget {
  const MarketHeader({super.key});

  @override
  State<MarketHeader> createState() => MarketHeaderState();
}

class MarketHeaderState extends State<MarketHeader> {
  List<IndexQuote> quotes = [];
  StreamSubscription? sub;

  @override
  void initState() {
    super.initState();
    sub = MarketDataService.instance.indexStream.listen((data) {
      if (mounted) setState(() => quotes = data);
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  String fmtPrice(double price) {
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

  Color changeColor(double change) {
    if (change > 0) return const Color(0xFF1A9E5C);
    if (change < 0) return const Color(0xFFD94040);
    return Colors.grey.shade600;
  }

  String fmtChange(double change, double pct) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)} ($sign${pct.toStringAsFixed(2)}%)';
  }

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return Container(
        height: 54,
        color: Colors.white,
        child: Center(
          child: Text('Connecting...', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(child: buildQuoteTile(quotes[0], showExchange: true)),
          Container(width: 1, height: 38, color: Colors.grey.shade200),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: buildQuoteTile(quotes[1], showExchange: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuoteTile(IndexQuote q, {required bool showExchange}) {
    final color = changeColor(q.change);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                q.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              ),
            ),
            if (showExchange && q.exchange.isNotEmpty) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(q.exchange, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              fmtPrice(q.price),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                fmtChange(q.change, q.changePercent),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: color),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
