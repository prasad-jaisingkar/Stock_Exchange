import 'dart:async';
import 'dart:math';
import '../models/stock.dart';
import '../models/index_quote.dart';

class _LivePrice {
  final double openPrice;
  double ltp;
  double momentum;

  _LivePrice({required this.openPrice, required this.ltp, this.momentum = 0});
}

class MarketDataService {
  static final MarketDataService instance = MarketDataService._internal();
  MarketDataService._internal();

  final Random rng = Random();

  final StreamController<List<IndexQuote>> indexController =
      StreamController<List<IndexQuote>>.broadcast();

  final StreamController<Map<String, Stock>> stockPriceController =
      StreamController<Map<String, Stock>>.broadcast();

  Stream<List<IndexQuote>> get indexStream => indexController.stream;
  Stream<Map<String, Stock>> get stockPriceStream => stockPriceController.stream;

  Timer? masterTimer;

  final double sensexOpen = 72450.55;
  final double niftyBankOpen = 54172.85;

  late _LivePrice sensexLive;
  late _LivePrice niftyBankLive;

  final Map<String, double> stockOpens = {
    'RELIANCE_NSE': 1374.00,
    'HDFCBANK_NSE': 966.85,
    'ASIANPAINT_NSE': 2537.40,
    'NIFTY IT_IDX': 35187.55,
    'RELIANCE SEP 1880 CE_NSE': 0.05,
    'RELIANCE SEP 1370 PE_NSE': 19.20,
    'MRF_NSE': 147625.00,
    'MRF_BSE': 147439.45,
    'TCS_NSE': 3845.60,
    'INFY_NSE': 1432.75,
    'WIPRO_NSE': 456.80,
    'HCLTECH_NSE': 1267.90,
    'TECHM_NSE': 1198.45,
    'TATASTEEL_NSE': 134.20,
    'JSWSTEEL_NSE': 867.35,
    'HINDALCO_NSE': 578.90,
    'COALINDIA_NSE': 432.55,
  };

  Map<String, _LivePrice> stockLive = {};
  int tickCount = 0;

  void startStreaming() {
    sensexLive = _LivePrice(openPrice: sensexOpen, ltp: sensexOpen);
    niftyBankLive = _LivePrice(openPrice: niftyBankOpen, ltp: niftyBankOpen);

    stockOpens.forEach((key, open) {
      stockLive[key] = _LivePrice(openPrice: open, ltp: open);
    });

    masterTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      tickCount++;
      _tickIndexes();
      if (tickCount % 2 == 0) _tickStocks();
    });
  }

  void _tickIndexes() {
    sensexLive = _nextTick(sensexLive, tickSizePct: 0.012, maxDriftPct: 1.5);
    niftyBankLive = _nextTick(niftyBankLive, tickSizePct: 0.010, maxDriftPct: 1.5);

    if (!indexController.isClosed) {
      indexController.add([
        IndexQuote(
          name: 'SENSEX',
          label: 'SENSEX 18TH SEP 8...',
          exchange: 'BSE',
          price: sensexLive.ltp,
          basePrice: sensexLive.openPrice,
        ),
        IndexQuote(
          name: 'NIFTY BANK',
          label: 'NIFTY BANK',
          exchange: '',
          price: niftyBankLive.ltp,
          basePrice: niftyBankLive.openPrice,
        ),
      ]);
    }
  }

  void _tickStocks() {
    final updated = <String, Stock>{};

    stockLive.forEach((key, live) {
      if (live.openPrice < 0.10) return;

      stockLive[key] = _nextTick(live, tickSizePct: 0.018, maxDriftPct: 2.0);
      final newLive = stockLive[key]!;

      final change = newLive.ltp - newLive.openPrice;
      final changePct = (change / newLive.openPrice) * 100;

      final parts = key.split('_');
      updated[key] = Stock(
        name: parts[0],
        exchange: parts[1],
        segment: '',
        price: newLive.ltp,
        change: change,
        changePercent: changePct,
      );
    });

    if (!stockPriceController.isClosed && updated.isNotEmpty) {
      stockPriceController.add(updated);
    }
  }

  // open price is fixed for the day — change is always relative to this
  // mean-reversion + momentum so price behaves like a real tick
  // clamp to avoid runaway drift
  _LivePrice _nextTick(_LivePrice live, {required double tickSizePct, required double maxDriftPct}) {
    final driftFraction = (live.ltp - live.openPrice) / live.openPrice;
    final reversion = -driftFraction * 0.3;
    final noise = (rng.nextDouble() * 2 - 1) * tickSizePct / 100;
    final newMomentum = live.momentum * 0.30 + noise + reversion * (tickSizePct / 100);

    double newLtp = live.ltp + live.ltp * newMomentum;

    final maxAllowed = live.openPrice * (1 + maxDriftPct / 100);
    final minAllowed = live.openPrice * (1 - maxDriftPct / 100);
    newLtp = newLtp.clamp(minAllowed, maxAllowed);
    newLtp = double.parse(newLtp.toStringAsFixed(2));

    return _LivePrice(openPrice: live.openPrice, ltp: newLtp, momentum: newMomentum);
  }

  void stopStreaming() {
    masterTimer?.cancel();
    masterTimer = null;
    tickCount = 0;
  }

  void dispose() {
    stopStreaming();
    indexController.close();
    stockPriceController.close();
  }
}
