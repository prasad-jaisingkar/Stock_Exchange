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

  String fmtChange(double change, double percent) {
    final sign = change >= 0 ? '' : '-';
    return '$sign${change.abs().toStringAsFixed(2)} (${sign}${percent.abs().toStringAsFixed(2)}%)';
  }

  Color changeColor(double change) {
    if (change > 0) return const Color(0xFF1A9E5C);
    if (change < 0) return const Color(0xFFD94040);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return Container(
        height: 52,
        color: Colors.white,
        child: Center(child: Text('Loading...', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))),
      );
    }

    final sensex = quotes[0];
    final niftyBank = quotes[1];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(child: buildQuoteTile(sensex, showExchange: true)),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: buildQuoteTile(niftyBank, showExchange: false),
          )),
        ],
      ),
    );
  }

  Widget buildQuoteTile(IndexQuote q, {required bool showExchange}) {
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
        const SizedBox(height: 3),
        Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                fmtPrice(q.price),
                key: ValueKey(q.price),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  fmtChange(q.change, q.changePercent),
                  key: ValueKey(q.change),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: changeColor(q.change)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
