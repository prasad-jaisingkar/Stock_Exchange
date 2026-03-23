import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/watchlist_bloc.dart';
import '../blocs/watchlist_event.dart';
import '../blocs/watchlist_state.dart';
import '../widgets/market_header.dart';
import '../widgets/stock_tile.dart';
import 'edit_watchlist_screen.dart';
import 'search_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => WatchlistScreenState();
}

class WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void openSortSheet(BuildContext context, int watchlistIndex) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text('Sort by',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade800)),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              sortRow(ctx, 'Name A → Z', Icons.sort_by_alpha, SortOption.nameAZ, watchlistIndex),
              sortRow(ctx, 'Name Z → A', Icons.sort_by_alpha, SortOption.nameZA, watchlistIndex),
              sortRow(ctx, 'Price: High to Low', Icons.arrow_downward, SortOption.priceHigh, watchlistIndex),
              sortRow(ctx, 'Price: Low to High', Icons.arrow_upward, SortOption.priceLow, watchlistIndex),
              sortRow(ctx, 'Top Gainers', Icons.trending_up, SortOption.gainers, watchlistIndex),
              sortRow(ctx, 'Top Losers', Icons.trending_down, SortOption.losers, watchlistIndex),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget sortRow(BuildContext ctx, String label, IconData icon, SortOption option, int watchlistIndex) {
    return InkWell(
      onTap: () {
        context.read<WatchlistBloc>().add(SortWatchlist(option, watchlistIndex: watchlistIndex));
        Navigator.pop(ctx);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final names = state.names.isEmpty
            ? ['Watchlist 1', 'Watchlist 5', 'Watchlist 6']
            : state.names;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const MarketHeader(),
                      Divider(height: 1, color: Colors.grey.shade200),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                              const SizedBox(width: 8),
                              Text('Search for instruments',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        indicatorWeight: 2,
                        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                        tabs: names.map((n) => Tab(text: n)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: List.generate(3, (i) => watchlistTab(i, state, names)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget watchlistTab(int index, WatchlistState state, List<String> names) {
    if (state.watchlists.isEmpty || index >= state.watchlists.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final stocks = state.watchlists[index];

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => openSortSheet(context, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tune, size: 14, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text('Sort by', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditWatchlistScreen(
                        watchlistIndex: index,
                        watchlistName: names[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text('Edit', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
        Expanded(
          child: ListView.separated(
            itemCount: stocks.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, i) => StockTile(stock: stocks[i]),
          ),
        ),
      ],
    );
  }
}
