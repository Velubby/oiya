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
import '../../widgets/oiya_product_graphic.dart';

class ResurfaceScreen extends ConsumerWidget {
  const ResurfaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resurfaced = ref.watch(resurfacedJournalNotesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 640) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const MobileHeader(title: 'Resurface'),
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
                      'Resurface.',
                      style: OiyaStyles.displayLg(color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ideas automatically surface at 7, 14, and 30-day intervals so they are never forgotten.',
                      style: OiyaStyles.leadAiry(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                    ),
                  ],
                ),
              ),
            ),
            if (resurfaced.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OiyaProductGraphic(isDark: isDark),
                          const SizedBox(height: 28),
                          Text(
                            'Nothing to resurface today',
                            style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Capture thoughts daily and they will automatically reappear here when their time is right.',
                            style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (crossAxisCount == 1)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final memory = resurfaced[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Dismissible(
                          key: Key('resurface-${memory.id}'),
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
                    childCount: resurfaced.length,
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
                      final memory = resurfaced[index];
                      return MemoryCard(
                        memory: memory,
                        onTap: () => openEditMemoryDialog(context, ref, memory),
                        onDelete: () => confirmDeleteMemory(context, ref, memory),
                      );
                    },
                    childCount: resurfaced.length,
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
