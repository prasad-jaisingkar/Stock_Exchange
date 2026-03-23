import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/watchlist_bloc.dart';
import '../blocs/watchlist_event.dart';
import '../blocs/watchlist_state.dart';

class EditWatchlistScreen extends StatefulWidget {
  final int watchlistIndex;
  final String watchlistName;

  const EditWatchlistScreen({
    super.key,
    required this.watchlistIndex,
    required this.watchlistName,
  });

  @override
  State<EditWatchlistScreen> createState() => EditWatchlistScreenState();
}

class EditWatchlistScreenState extends State<EditWatchlistScreen> {
  late TextEditingController nameController;
  bool editingName = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.watchlistName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void saveName() {
    final trimmed = nameController.text.trim();
    if (trimmed.isEmpty) {
      nameController.text = widget.watchlistName;
    } else {
      context.read<WatchlistBloc>().add(
        RenameWatchlist(widget.watchlistIndex, trimmed),
      );
    }
    setState(() => editingName = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            final name = state.nameAt(widget.watchlistIndex);
            return Text(
              'Edit $name',
              style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
            );
          },
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Colors.grey.shade200),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: editingName
                      ? TextField(
                          controller: nameController,
                          autofocus: true,
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          onSubmitted: (_) => saveName(),
                        )
                      : BlocBuilder<WatchlistBloc, WatchlistState>(
                          builder: (context, state) {
                            return Text(
                              state.nameAt(widget.watchlistIndex),
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            );
                          },
                        ),
                ),
                const SizedBox(width: 12),
                editingName
                    ? GestureDetector(
                        onTap: saveName,
                        child: const Icon(Icons.check, size: 20, color: Colors.black),
                      )
                    : GestureDetector(
                        onTap: () => setState(() => editingName = true),
                        child: Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade500),
                      ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Expanded(
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state.watchlists.isEmpty || widget.watchlistIndex >= state.watchlists.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stocks = state.watchlists[widget.watchlistIndex];

                return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: stocks.length,
                  onReorder: (oldIndex, newIndex) {
                    context.read<WatchlistBloc>().add(
                      ReorderStock(oldIndex, newIndex, watchlistIndex: widget.watchlistIndex),
                    );
                  },
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    return stockRow(context, stock.name, index);
                  },
                );
              },
            ),
          ),
          bottomButtons(context),
        ],
      ),
    );
  }

  Widget stockRow(BuildContext context, String name, int index) {
    return Container(
      key: ValueKey('${widget.watchlistIndex}-$name-$index'),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, color: Colors.black54, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(name, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<WatchlistBloc>().add(
                      DeleteStock(index, watchlistIndex: widget.watchlistIndex),
                    );
                  },
                  child: const Icon(Icons.delete_outline, color: Colors.black, size: 22),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
        ],
      ),
    );
  }

  Widget bottomButtons(BuildContext context) {
    final others = <Map<String, dynamic>>[
      {'name': 'Watchlist 1', 'index': 0},
      {'name': 'Watchlist 5', 'index': 1},
      {'name': 'Watchlist 6', 'index': 2},
    ].where((w) => w['index'] != widget.watchlistIndex).toList();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
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
                          child: Text(
                            'Select Watchlist to Edit',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200),
                        ...others.map((w) {
                          return BlocBuilder<WatchlistBloc, WatchlistState>(
                            builder: (context, state) {
                              final displayName = state.nameAt(w['index'] as int);
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(ctx);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditWatchlistScreen(
                                        watchlistIndex: w['index'] as int,
                                        watchlistName: displayName,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.list_alt_outlined, size: 18),
                                      const SizedBox(width: 14),
                                      Text(displayName,
                                          style: const TextStyle(fontSize: 14, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Edit other watchlists',
                style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (editingName) saveName();
              Navigator.pop(context);
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Save Watchlist',
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
