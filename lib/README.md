# 021Trade Watchlist — Flutter Assignment

Flutter app built for the 021Trade developer assignment. Implements a stock watchlist with BLoC state management, live price simulation via streams, and drag-to-reorder functionality.

---

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── stock.dart
│   └── index_quote.dart
├── blocs/
│   ├── watchlist_bloc.dart
│   ├── watchlist_event.dart
│   └── watchlist_state.dart
├── services/
│   └── market_data_service.dart
├── screens/
│   ├── watchlist_screen.dart
│   ├── edit_watchlist_screen.dart
│   ├── search_screen.dart
│   ├── orders_screen.dart
│   ├── gtt_screen.dart
│   ├── portfolio_screen.dart
│   ├── funds_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── stock_tile.dart
    └── market_header.dart
```

---

## BLoC Architecture

### Events

| Event | What it does |
|-------|-------------|
| `LoadWatchlist` | Populates all three watchlists with sample data |
| `ReorderStock(oldIndex, newIndex, watchlistIndex)` | Moves a stock within a specific watchlist |
| `DeleteStock(stockIndex, watchlistIndex)` | Removes a stock from a specific watchlist |
| `SortWatchlist(option, watchlistIndex)` | Sorts a watchlist by name, price, or % change |
| `RenameWatchlist(watchlistIndex, newName)` | Updates the display name of a watchlist |

### State

`WatchlistState` holds two lists — `watchlists` (the stock data across all three tabs) and `names` (the editable display names for each tab). The `nameAt(index)` helper is used throughout the UI so name changes reflect everywhere immediately.

### Bloc

Uses the handler-based `on<Event>()` API. Each handler creates a fresh copy of the list before mutating, so the original state is never touched directly.

---

## Live Price Streaming

`MarketDataService` is a singleton that runs a single `Timer.periodic` at 1.2 second intervals. It maintains two types of streams — one for index quotes (SENSEX, NIFTY BANK) and one for individual stock prices.

Each instrument tracks its day open price separately from its current LTP. The change value shown in the UI is always `ltp - openPrice`, which matches how real trading apps display it.

Price movement uses three forces: random noise, momentum carry-over from the previous tick, and mean-reversion that pulls prices back toward the open when they drift too far. A hard clamp prevents any price from moving more than 2% from its open.

`StockTile` and `MarketHeader` each hold their own `StreamSubscription` and cancel it in `dispose()`.

---

## Reorder Logic

`ReorderableListView` internally adjusts `newIndex` when dragging forward, so a correction is needed:

```dart
if (newIndex > oldIndex) newIndex -= 1;
```

`ReorderableDragStartListener` wraps only the drag handle icon, so the delete button and stock name don't accidentally start a drag.

---

## Watchlist Name Editing

Tapping the pencil icon in the edit screen switches the name label into an inline `TextField`. Saving fires `RenameWatchlist` to the bloc, which updates `WatchlistState.names`. The tab bar and the edit screen title both rebuild from state, so the new name appears everywhere at once.

---

## How to Run


flutter pub get
flutter run

Requires Flutter 3.0+ / Dart 3.0+.
