import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journal/controllers/journal_controller.dart';
import '../../style/oiya_styles.dart';
import '../../widgets/floating_toast.dart';
import '../../widgets/journal_actions.dart';
import '../../widgets/memory_card.dart';
import '../../widgets/mobile_header.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final currentFilter = ref.watch(searchFilterProvider);
    final results = ref.watch(filteredJournalNotesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const MobileHeader(title: 'Search'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search.',
                      style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).state = value,
                      style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
                      decoration: InputDecoration(
                        hintText: 'Cari catatan atau ide...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black38,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                          size: 20,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  ref.read(searchQueryProvider.notifier).state = '';
                                },
                                child: Icon(
                                  CupertinoIcons.clear_thick_circled,
                                  color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                                  size: 20,
                                ),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: const BorderSide(
                            color: OiyaStyles.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _SearchFilterChip(
                            label: 'All Memories',
                            isSelected: currentFilter == SearchFilter.all,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.all;
                            },
                          ),
                          const SizedBox(width: 8),
                          _SearchFilterChip(
                            label: 'Created Today',
                            isSelected: currentFilter == SearchFilter.today,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.today;
                            },
                          ),
                          const SizedBox(width: 8),
                          _SearchFilterChip(
                            label: 'Recent (3d)',
                            isSelected: currentFilter == SearchFilter.recent,
                            onTap: () {
                              ref.read(searchFilterProvider.notifier).state = SearchFilter.recent;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.surfacePearl,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: OiyaStyles.dividerSoft),
                      ),
                      child: Text(
                        query.trim().isEmpty
                            ? 'All Saved (${results.length})'
                            : 'Results for "$query" (${results.length})',
                        style: OiyaStyles.captionStrong(
                          color: isDark ? Colors.white : OiyaStyles.inkMuted80,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.search_circle,
                        size: 48,
                        color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No matching memories found.',
                        style: OiyaStyles.caption(
                          color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (crossAxisCount == 1)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = results[results.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key('search-${memory.id}'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            HapticFeedback.mediumImpact();
                            await ref.read(journalControllerProvider.notifier).deleteMemory(memory.id);
                            if (context.mounted) {
                              showOiyaToast(context, 'Memory deleted.');
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3B30),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 20),
                          ),
                          child: MemoryCard(
                            memory: memory,
                            onTap: () => openEditMemoryDialog(context, ref, memory),
                            onDelete: () => confirmDeleteMemory(context, ref, memory),
                          ),
                        ),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = results[results.length - 1 - index];
                      return MemoryCard(
                        memory: memory,
                        onTap: () => openEditMemoryDialog(context, ref, memory),
                        onDelete: () => confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: results.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchFilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SearchFilterChip> createState() => _SearchFilterChipState();
}

class _SearchFilterChipState extends State<_SearchFilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color selectedBg = isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary;
    final Color selectedText = isDark ? OiyaStyles.ink : Colors.white;
    
    final Color unselectedBg = isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl;
    final Color unselectedText = isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80;
    final Color unselectedBorder = isDark ? const Color(0xFF333333) : OiyaStyles.dividerSoft;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected ? selectedBg : unselectedBg,
            borderRadius: BorderRadius.circular(OiyaStyles.roundedPill),
            border: Border.all(
              color: widget.isSelected ? selectedBg : unselectedBorder,
              width: 1.0,
            ),
          ),
          child: Text(
            widget.label,
            style: OiyaStyles.captionStrong(
              color: widget.isSelected ? selectedText : unselectedText,
            ),
          ),
        ),
      ),
    );
  }
}
