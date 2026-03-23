class Stock {
  final String name;
  final String exchange;
  final String segment;
  final double price;
  final double change;
  final double changePercent;

  Stock({
    required this.name,
    required this.exchange,
    required this.segment,
    required this.price,
    required this.change,
    required this.changePercent,
  });

  Stock copyWith({
    String? name,
    String? exchange,
    String? segment,
    double? price,
    double? change,
    double? changePercent,
  }) {
    return Stock(
      name: name ?? this.name,
      exchange: exchange ?? this.exchange,
      segment: segment ?? this.segment,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
    );
  }
}
