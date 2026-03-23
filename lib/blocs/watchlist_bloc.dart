import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/stock.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(WatchlistState([], [])) {
    on<LoadWatchlist>(loadStocks);
    on<ReorderStock>(onReorder);
    on<DeleteStock>(removeStock);
    on<SortWatchlist>(applySorting);
    on<RenameWatchlist>(renameList);
  }

  void loadStocks(LoadWatchlist event, Emitter<WatchlistState> emit) {
    final watchlist1 = [
      Stock(name: 'RELIANCE', exchange: 'NSE', segment: 'EQ', price: 1374.00, change: -4.50, changePercent: -0.33),
      Stock(name: 'HDFCBANK', exchange: 'NSE', segment: 'EQ', price: 966.85, change: 0.85, changePercent: 0.09),
      Stock(name: 'ASIANPAINT', exchange: 'NSE', segment: 'EQ', price: 2537.40, change: 6.60, changePercent: 0.26),
      Stock(name: 'NIFTY IT', exchange: 'IDX', segment: '', price: 35187.55, change: 877.11, changePercent: 2.56),
      Stock(name: 'RELIANCE SEP 1880 CE', exchange: 'NSE', segment: 'Monthly', price: 0.00, change: 0.00, changePercent: 0.00),
      Stock(name: 'RELIANCE SEP 1370 PE', exchange: 'NSE', segment: 'Monthly', price: 19.20, change: 1.00, changePercent: 5.49),
      Stock(name: 'MRF', exchange: 'NSE', segment: 'EQ', price: 147625.00, change: 550.00, changePercent: 0.37),
      Stock(name: 'MRF', exchange: 'BSE', segment: 'EQ', price: 147439.45, change: 463.80, changePercent: 0.32),
    ];

    final watchlist5 = [
      Stock(name: 'TCS', exchange: 'NSE', segment: 'EQ', price: 3845.60, change: 45.20, changePercent: 1.19),
      Stock(name: 'INFY', exchange: 'NSE', segment: 'EQ', price: 1432.75, change: -12.30, changePercent: -0.85),
      Stock(name: 'WIPRO', exchange: 'NSE', segment: 'EQ', price: 456.80, change: 3.40, changePercent: 0.75),
      Stock(name: 'HCLTECH', exchange: 'NSE', segment: 'EQ', price: 1267.90, change: 18.60, changePercent: 1.49),
      Stock(name: 'TECHM', exchange: 'NSE', segment: 'EQ', price: 1198.45, change: -8.75, changePercent: -0.72),
    ];

    final watchlist6 = [
      Stock(name: 'TATASTEEL', exchange: 'NSE', segment: 'EQ', price: 134.20, change: 2.10, changePercent: 1.59),
      Stock(name: 'JSWSTEEL', exchange: 'NSE', segment: 'EQ', price: 867.35, change: -5.65, changePercent: -0.65),
      Stock(name: 'HINDALCO', exchange: 'NSE', segment: 'EQ', price: 578.90, change: 7.80, changePercent: 1.37),
      Stock(name: 'COALINDIA', exchange: 'NSE', segment: 'EQ', price: 432.55, change: -3.20, changePercent: -0.73),
    ];

    emit(WatchlistState(
      [watchlist1, watchlist5, watchlist6],
      ['Watchlist 1', 'Watchlist 5', 'Watchlist 6'],
    ));
  }

  void onReorder(ReorderStock event, Emitter<WatchlistState> emit) {
    final allLists = List<List<Stock>>.from(
      state.watchlists.map((w) => List<Stock>.from(w)),
    );

    final list = allLists[event.watchlistIndex];
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    emit(WatchlistState(allLists, List.from(state.names)));
  }

  void removeStock(DeleteStock event, Emitter<WatchlistState> emit) {
    final allLists = List<List<Stock>>.from(
      state.watchlists.map((w) => List<Stock>.from(w)),
    );
    allLists[event.watchlistIndex].removeAt(event.stockIndex);
    emit(WatchlistState(allLists, List.from(state.names)));
  }

  void applySorting(SortWatchlist event, Emitter<WatchlistState> emit) {
    final allLists = List<List<Stock>>.from(
      state.watchlists.map((w) => List<Stock>.from(w)),
    );
    final list = allLists[event.watchlistIndex];

    switch (event.option) {
      case SortOption.nameAZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameZA:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.gainers:
        list.sort((a, b) => b.changePercent.compareTo(a.changePercent));
        break;
      case SortOption.losers:
        list.sort((a, b) => a.changePercent.compareTo(b.changePercent));
        break;
      case SortOption.none:
        break;
    }

    emit(WatchlistState(allLists, List.from(state.names)));
  }

  void renameList(RenameWatchlist event, Emitter<WatchlistState> emit) {
    final updatedNames = List<String>.from(state.names);
    updatedNames[event.watchlistIndex] = event.newName.trim();
    emit(WatchlistState(List.from(state.watchlists), updatedNames));
  }
}
