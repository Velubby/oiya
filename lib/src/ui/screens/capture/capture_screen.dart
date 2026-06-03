import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/journal/controllers/journal_controller.dart';
import '../../style/oiya_styles.dart';
import '../../widgets/floating_toast.dart';
import '../../widgets/mobile_header.dart';
import '../../widgets/oiya_button.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key, required this.onCaptureSaved});

  final VoidCallback onCaptureSaved;

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isSaving = false;
  int _sessionCount = 0;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCharCount);
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
      await ref.read(journalControllerProvider.notifier).addMemory(text);
      HapticFeedback.mediumImpact();
      _controller.clear();
      if (!mounted) return;

      final isThoughtDump = ref.read(thoughtDumpModeProvider);
      if (!isThoughtDump) {
        showOiyaToast(context, 'Memory saved.');
        widget.onCaptureSaved();
      } else {
        setState(() {
          _sessionCount++;
        });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? OiyaStyles.surfaceBlack : OiyaStyles.canvasParchment,
      appBar: const MobileHeader(title: 'Capture'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const ValueKey<String>('capture-input'),
                      controller: _controller,
                      focusNode: _inputFocusNode,
                      autofocus: !kIsWeb, // Safely autofocus only on native platforms
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 500,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox(),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _save(),
                      style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
                      decoration: InputDecoration(
                        hintText: isThoughtDump
                            ? 'Write quickly, click Save to continue...'
                            : 'Write ideas, memos, or quick notes...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black38,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: OiyaStyles.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Character Count',
                          style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                        ),
                        Text(
                          '$_charCount / 500',
                          style: OiyaStyles.captionStrong(
                            color: _charCount >= 500
                               ? Theme.of(context).colorScheme.error
                                : (isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: OiyaStyles.hairline, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thought Dump Mode',
                          style: OiyaStyles.bodyStrong(color: isDark ? Colors.white : OiyaStyles.ink),
                        ),
                        CupertinoSwitch(
                          activeColor: OiyaStyles.primary,
                          value: isThoughtDump,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            ref.read(thoughtDumpModeProvider.notifier).state = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Keep keyboard open for rapid entry stacks.',
                      style: OiyaStyles.finePrint(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted48),
                    ),
                  ],
                ),
              ),
              if (isThoughtDump && _sessionCount > 0) ...[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x1F30D158),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF30D158), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Captured $_sessionCount ideas this session',
                          style: OiyaStyles.captionStrong(color: const Color(0xFF30D158)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OiyaButton(
                  label: _isSaving
                      ? 'Saving...'
                      : isThoughtDump
                          ? 'Save & Continue'
                          : 'Save to Vault',
                  isPrimary: true,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CupertinoActivityIndicator(radius: 8, color: Colors.white),
                        )
                      : Icon(
                          isThoughtDump ? CupertinoIcons.paperplane_fill : CupertinoIcons.checkmark_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
