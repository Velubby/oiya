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

    return Scaffold(
      appBar: AppBar(
        title: const Text('OIYA'),
        centerTitle: true,
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.flash_on_outlined), label: 'Capture'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Resurface'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        onDestinationSelected: _goToTab,
      ),
    );
  }
}

class _HomePage extends ConsumerWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memories = ref.watch(memoryControllerProvider);

    if (memories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Belum ada memory. Mulai dari tab Capture dan simpan pikiran pertama kamu.',
            textAlign: TextAlign.center,
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
          trailing: IconButton(
            tooltip: 'Hapus memory',
            onPressed: () {
              ref
                  .read(memoryControllerProvider.notifier)
                  .deleteMemory(memory.id);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    await ref.read(memoryControllerProvider.notifier).addMemory(text);
    _controller.clear();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory tersimpan.')),
    );
    widget.onCaptureSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 4,
            maxLines: 8,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  'Tulis cepat sebelum lupa... contoh: Parkir di basement B2',
              labelText: 'Quick Capture',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Memory'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPage extends ConsumerWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(filteredMemoriesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Cari memory: flutter, parkir, belut...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              query.trim().isEmpty
                  ? 'Menampilkan semua memory'
                  : 'Hasil untuk "$query"',
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Tidak ada memory yang cocok.'))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final memory = results[index];
                      return _MemoryCard(memory: memory);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resurfaced = ref.watch(resurfacedMemoriesProvider);

    if (resurfaced.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Belum ada memory yang masuk momentum 7/14/30 hari. Tetap capture setiap hari, memory lama akan muncul di sini.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final memory = resurfaced[index];
        return _MemoryCard(memory: memory);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: resurfaced.length,
    );
  }
}

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Theme'),
          subtitle: Text('Pilih mode tampilan OIYA'),
        ),
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
  const _MemoryCard({required this.memory, this.trailing});

  final MemoryNote memory;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      child: ListTile(
        title: Text(memory.text),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(formatter.format(memory.createdAt)),
        ),
        trailing: trailing,
      ),
    );
  }
}
