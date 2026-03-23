abstract class WatchlistEvent {}

class LoadWatchlist extends WatchlistEvent {}

class ReorderStock extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;
  final int watchlistIndex;

  ReorderStock(this.oldIndex, this.newIndex, {this.watchlistIndex = 0});
}

class DeleteStock extends WatchlistEvent {
  final int stockIndex;
  final int watchlistIndex;

  DeleteStock(this.stockIndex, {this.watchlistIndex = 0});
}

class SortWatchlist extends WatchlistEvent {
  final SortOption option;
  final int watchlistIndex;

  SortWatchlist(this.option, {this.watchlistIndex = 0});
}

class RenameWatchlist extends WatchlistEvent {
  final int watchlistIndex;
  final String newName;

  RenameWatchlist(this.watchlistIndex, this.newName);
}

enum SortOption { none, nameAZ, nameZA, priceHigh, priceLow, gainers, losers }
