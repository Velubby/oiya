import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/journal/controllers/journal_controller.dart';
import '../style/oiya_styles.dart';
import 'floating_toast.dart';
import 'oiya_button.dart';

class QuickCaptureSheet extends ConsumerStatefulWidget {
  const QuickCaptureSheet({super.key});

  @override
  ConsumerState<QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends ConsumerState<QuickCaptureSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

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
      if (mounted) {
        Navigator.of(context).pop();
        showOiyaToast(context, 'Memory saved.');
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Capture',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: OiyaStyles.captionStrong(color: OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: !kIsWeb, // Safely autofocus only on native platforms
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
            decoration: InputDecoration(
              hintText: 'Write quickly before you forget...',
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OiyaButton(
              label: _isSaving ? 'Saving...' : 'Save',
              isPrimary: true,
              icon: _isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CupertinoActivityIndicator(radius: 8, color: Colors.white),
                    )
                  : null,
              onPressed: _save,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Future<void> runWithBlockingLoader(
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
