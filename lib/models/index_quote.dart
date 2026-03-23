class IndexQuote {
  final String name;
  final String label;
  final String exchange;
  final double price;
  final double basePrice;

  IndexQuote({
    required this.name,
    required this.label,
    required this.exchange,
    required this.price,
    required this.basePrice,
  });

  double get change => price - basePrice;
  double get changePercent => (change / basePrice) * 100;
}
