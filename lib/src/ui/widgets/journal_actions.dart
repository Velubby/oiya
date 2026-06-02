import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/journal/controllers/journal_controller.dart';
import '../../features/journal/models/journal_note.dart';
import 'floating_toast.dart';
import 'quick_capture_sheet.dart'; // contains runWithBlockingLoader

Future<void> openEditMemoryDialog(
  BuildContext context,
  WidgetRef ref,
  JournalNote memory,
) async {
  final controller = TextEditingController(text: memory.text);
  final nextText = await showCupertinoDialog<String>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Edit memory'),
      content: Container(
        padding: const EdgeInsets.only(top: 12),
        child: CupertinoTextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          maxLength: 500,
          placeholder: 'Memory content',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('Save'),
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

  await runWithBlockingLoader(
    context,
    message: 'Saving changes...',
    action: () => ref
        .read(journalControllerProvider.notifier)
        .updateMemory(memory.id, nextText),
  );
}

Future<void> confirmDeleteMemory(
  BuildContext context,
  WidgetRef ref,
  JournalNote memory,
) async {
  final confirm = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Delete memory?'),
      content: const Text('This memory will be lost forever.'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true && context.mounted) {
    HapticFeedback.mediumImpact();
    await runWithBlockingLoader(
      context,
      message: 'Deleting...',
      action: () => ref
          .read(journalControllerProvider.notifier)
          .deleteMemory(memory.id),
    );
    if (context.mounted) {
      showOiyaToast(context, 'Memory deleted.');
    }
  }
}
