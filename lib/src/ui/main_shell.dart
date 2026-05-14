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
      extendBody: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [scheme.primary, scheme.secondary],
              ).createShader(bounds),
          child: const Text('OIYA', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withOpacity(0.25),
              scheme.secondaryContainer.withOpacity(0.2),
              scheme.surface,
            ],
          ),
        ),
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
          borderRadius: BorderRadius.circular(22),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.flash_on_outlined),
                selectedIcon: Icon(Icons.flash_on_rounded),
                label: 'Capture',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'Resurface',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
            onDestinationSelected: _goToTab,
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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus memory ini?'),
            content: const Text(
              'Aksi ini tidak bisa dibatalkan. Yakin mau hapus?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton(
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
      action:
          () => ref.read(memoryControllerProvider.notifier).deleteMemory(
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
    final nextText = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit memory'),
            content: TextField(
              key: const ValueKey<String>('edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
              decoration: const InputDecoration(labelText: 'Isi memory'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed:
                    () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
    );
    controller.dispose();

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action:
          () => ref
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
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 38),
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
            icon: const Icon(Icons.delete_outline),
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
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [scheme.primaryContainer, scheme.secondaryContainer],
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Thought Dump Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Switch(
                  value: isThoughtDump,
                  onChanged: (value) {
                    ref.read(thoughtDumpModeProvider.notifier).state = value;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isSaving) const LinearProgressIndicator(minHeight: 2.5),
          if (_isSaving) const SizedBox(height: 12),
          TextField(
            key: const ValueKey<String>('capture-input'),
            controller: _controller,
            focusNode: _inputFocusNode,
            autofocus: true,
            minLines: 5,
            maxLines: 8,
            maxLength: 500,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText:
                  isThoughtDump
                      ? 'Drop semua ide cepat di sini, enter untuk terus lanjut.'
                      : 'Tulis cepat sebelum lupa... contoh: Parkir di basement B2',
              labelText: isThoughtDump ? 'Thought Dump' : 'Quick Capture',
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon:
                  _isSaving
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Icon(
                        isThoughtDump ? Icons.send_rounded : Icons.save_outlined,
                      ),
              label: Text(
                _isSaving
                    ? 'Menyimpan...'
                    : isThoughtDump
                    ? 'Simpan & Lanjut'
                    : 'Simpan Memory',
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
    final nextText = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit memory'),
            content: TextField(
              key: const ValueKey<String>('search-edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed:
                    () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
    );
    controller.dispose();

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action:
          () => ref
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
          TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              hintText: 'Cari memory: flutter, parkir, belut...',
              prefixIcon: Icon(Icons.search),
            ),
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
            child:
                results.isEmpty
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
          ),
        ],
      ),
    );
  }
}

class _ResurfacePage extends ConsumerWidget {
  const _ResurfacePage();

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    MemoryNote memory,
  ) async {
    final controller = TextEditingController(text: memory.text);
    final nextText = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit memory'),
            content: TextField(
              key: const ValueKey<String>('resurface-edit-memory-input'),
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 500,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed:
                    () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
    );
    controller.dispose();

    if (nextText == null ||
        nextText.isEmpty ||
        nextText == memory.text ||
        !context.mounted) {
      return;
    }

    await _runWithBlockingLoader(
      context,
      message: 'Menyimpan perubahan...',
      action:
          () => ref
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
            subtitle: Text('Pilih vibe tampilan OIYA'),
          ),
        ),
        const SizedBox(height: 12),
        RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: themeMode,
          title: const Text('System'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: themeMode,
          title: const Text('Light'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: themeMode,
          title: const Text('Dark'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
        ),
        const Divider(height: 24),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.cloud_outlined),
          title: Text('Backup & Sync'),
          subtitle: Text('Coming soon pada fase berikutnya.'),
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

    return Card(
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: scheme.surface.withOpacity(0.75),
        title: Text(memory.text, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            formatter.format(memory.createdAt),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}

Future<void> _runWithBlockingLoader(
  BuildContext context, {
  required String message,
  required Future<void> Function() action,
}) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Row(
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(message)),
              ],
            ),
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
