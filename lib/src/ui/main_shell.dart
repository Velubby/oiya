import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../features/memory/memory_controller.dart';
import '../features/memory/memory_note.dart';
import '../features/settings/theme_mode_controller.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _QuickCaptureSheet extends ConsumerStatefulWidget {
  const _QuickCaptureSheet({super.key});

  @override
  ConsumerState<_QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends ConsumerState<_QuickCaptureSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(memoryControllerProvider.notifier).addMemory(text);
      if (!mounted) return;
      Navigator.of(context).pop();
        _showCupertinoToast(context, 'Memory tersimpan.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
                Icon(CupertinoIcons.bolt_fill),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quick Capture',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _controller,
            autofocus: true,
            minLines: 1,
            maxLines: 6,
            maxLength: 300,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            placeholder: 'Tulis cepat sebelum lupa...',
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              const Spacer(),
              CupertinoButton.filled(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CupertinoActivityIndicator(radius: 9),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _HomePage(),
      _CapturePage(onCaptureSaved: () => _goToTab(0)),
      const _SearchPage(),
      const _ResurfacePage(),
      const _SettingsPage(),
    ];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: CupertinoButton.filled(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(32),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: const _QuickCaptureSheet(),
            ),
          );
        },
        child: const Icon(CupertinoIcons.bolt_fill),
      ),
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: CupertinoNavigationBar(
              backgroundColor: scheme.surface.withOpacity(0.72),
              middle: Text('OIYA', style: Theme.of(context).appBarTheme.titleTextStyle),
              border: null,
            ),
          ),
        ),
      ),
      body: Container(
        color: scheme.surface,
        child: SafeArea(
          top: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: IndexedStack(
              key: ValueKey<int>(_currentIndex),
              index: _currentIndex,
              children: pages,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: CupertinoTabBar(
                currentIndex: _currentIndex,
                backgroundColor: scheme.surface.withOpacity(0.78),
                activeColor: scheme.primary,
                items: const [
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.bolt_fill), label: 'Capture'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.time), label: 'Resurface'),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings'),
                ],
                onTap: _goToTab,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePage extends ConsumerWidget {
  const _HomePage();

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    MemoryNote memory,
  ) async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Hapus memory ini?'),
        content: const Text('Aksi ini tidak bisa dibatalkan. Yakin mau hapus?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menghapus memory...',
      action: () => ref.read(memoryControllerProvider.notifier).deleteMemory(
            memory.id,
          ),
    );
  }

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    MemoryNote memory,
  ) async {
    final controller = TextEditingController(text: memory.text);
    final nextText = await showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit memory'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              key: const ValueKey<String>('edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
              placeholder: 'Isi memory',
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action: () => ref
          .read(memoryControllerProvider.notifier)
          .updateMemory(memory.id, nextText),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(memoryControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    if (memories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
              child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.sparkles, size: 38),
                SizedBox(height: 12),
                Text(
                  'Belum ada memory. Buka tab Capture lalu simpan ide pertamamu.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final memory = memories[index];
        return _MemoryCard(
          memory: memory,
          onTap: () => _openEditDialog(context, ref, memory),
          trailing: IconButton(
            tooltip: 'Hapus memory',
            onPressed: () => _confirmDelete(context, ref, memory),
            icon: const Icon(CupertinoIcons.delete_simple),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: memories.length,
    );
  }
}

class _CapturePage extends ConsumerStatefulWidget {
  const _CapturePage({required this.onCaptureSaved});

  final VoidCallback onCaptureSaved;

  @override
  ConsumerState<_CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<_CapturePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(memoryControllerProvider.notifier).addMemory(text);
      _controller.clear();
      if (!mounted) {
        return;
      }

      final isThoughtDump = ref.read(thoughtDumpModeProvider);
      if (!isThoughtDump) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Memory tersimpan.')));
        widget.onCaptureSaved();
      } else {
        _inputFocusNode.requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isThoughtDump = ref.watch(thoughtDumpModeProvider);
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: scheme.surfaceContainerHighest.withOpacity(0.6),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Thought Dump Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                CupertinoSwitch(
                  value: isThoughtDump,
                  onChanged: (value) =>
                      ref.read(thoughtDumpModeProvider.notifier).state = value,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isSaving) const LinearProgressIndicator(minHeight: 2.5),
          if (_isSaving) const SizedBox(height: 12),
          CupertinoTextField(
            key: const ValueKey<String>('capture-input'),
            controller: _controller,
            focusNode: _inputFocusNode,
            autofocus: true,
            minLines: 5,
            maxLines: 8,
            maxLength: 500,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            placeholder: isThoughtDump
                ? 'Drop semua ide cepat di sini, enter untuk terus lanjut.'
                : 'Tulis cepat sebelum lupa... contoh: Parkir di basement B2',
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _isSaving ? null : _save,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CupertinoActivityIndicator(radius: 9),
                        )
                      : Icon(isThoughtDump
                          ? CupertinoIcons.paperplane_fill
                          : CupertinoIcons.check_mark),
                  const SizedBox(width: 8),
                  Text(
                    _isSaving
                        ? 'Menyimpan...'
                        : isThoughtDump
                            ? 'Simpan & Lanjut'
                            : 'Simpan Memory',
                  ),
                ],
              ),
            ),
          ),
          if (isThoughtDump) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Mode ini simpan memory tanpa pindah halaman supaya flow ide tetap jalan.',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchPage extends ConsumerWidget {
  const _SearchPage();

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    MemoryNote memory,
  ) async {
    final controller = TextEditingController(text: memory.text);
    final nextText = await showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit memory'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              key: const ValueKey<String>('search-edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action: () => ref
          .read(memoryControllerProvider.notifier)
          .updateMemory(memory.id, nextText),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(filteredMemoriesProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CupertinoSearchTextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            placeholder: 'Cari memory: flutter, parkir, belut...',
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                query.trim().isEmpty
                    ? 'Menampilkan semua memory (${results.length})'
                    : 'Hasil untuk "$query" (${results.length})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Tidak ada memory yang cocok.'))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final memory = results[index];
                      return _MemoryCard(
                        memory: memory,
                        onTap: () => _openEditDialog(context, ref, memory),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: results.length,
                  ),
class _ResurfacePage extends ConsumerWidget {
  const _ResurfacePage();

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    MemoryNote memory,
  ) async {
    final controller = TextEditingController(text: memory.text);
    final nextText = await showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit memory'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              key: const ValueKey<String>('resurface-edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action: () => ref
          .read(memoryControllerProvider.notifier)
          .updateMemory(memory.id, nextText),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resurfaced = ref.watch(resurfacedMemoriesProvider);
    final scheme = Theme.of(context).colorScheme;

    if (resurfaced.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: const Text(
              'Belum ada memory yang masuk momentum 7/14/30 hari. Capture rutin biar memory lama muncul di sini.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final memory = resurfaced[index];
        return _MemoryCard(
          memory: memory,
          onTap: () => _openEditDialog(context, ref, memory),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: resurfaced.length,
    );
  }
}

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [scheme.primaryContainer, scheme.tertiaryContainer],
            ),
          ),
          child: const ListTile(
            title: Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            subtitle: Text('Pilih vibe tampilan oiya'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: CupertinoSegmentedControl<ThemeMode>(
            groupValue: themeMode,
            children: const {
              ThemeMode.system: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('System'),
              ),
              ThemeMode.light: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Light'),
              ),
              ThemeMode.dark: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text('Dark'),
              ),
            },
            onValueChanged: (value) => ref.read(themeModeProvider.notifier).setThemeMode(value),
          ),
        ),
        const Divider(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(CupertinoIcons.cloud),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Backup & Sync', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Coming soon pada fase berikutnya.'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.memory, this.trailing, this.onTap});

  final MemoryNote memory;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(memory.text, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    formatter.format(memory.createdAt),
                    style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _runWithBlockingLoader(
  BuildContext context, {
  required String message,
  required Future<void> Function() action,
}) async {
  showCupertinoDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CupertinoAlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CupertinoActivityIndicator(radius: 11),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );

  try {
    await action();
  } finally {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

void _showCupertinoToast(BuildContext context, String message) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        ),
      ),
    ),
  );
  Future.delayed(const Duration(milliseconds: 900), () {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  });
}
