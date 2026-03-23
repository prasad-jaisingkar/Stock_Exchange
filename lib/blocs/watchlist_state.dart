import '../models/stock.dart';

class WatchlistState {
  final List<List<Stock>> watchlists;
  final List<String> names;

  WatchlistState(this.watchlists, this.names);

  List<Stock> get stocks => watchlists.isNotEmpty ? watchlists[0] : [];

  String nameAt(int index) =>
      index < names.length ? names[index] : 'Watchlist ${index + 1}';
}
