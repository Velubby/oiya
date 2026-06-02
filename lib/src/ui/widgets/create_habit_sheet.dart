import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/habits/controllers/habit_controller.dart';
import '../style/oiya_styles.dart';
import 'floating_toast.dart';
import 'oiya_button.dart';

class CreateHabitSheet extends ConsumerStatefulWidget {
  const CreateHabitSheet({super.key});

  @override
  ConsumerState<CreateHabitSheet> createState() => _CreateHabitSheetState();
}

class _CreateHabitSheetState extends ConsumerState<CreateHabitSheet> {
  final TextEditingController _titleController = TextEditingController();
  String _proofType = 'none'; // 'none' or 'image'
  String _scheduleType = 'daily'; // 'daily', 'custom', 'exam', 'specific'

  final List<int> _selectedWeeklyDays = [];
  final List<DateTime> _selectedExamDates = [];

  DateTime? _selectedSpecificDate;
  int? _selectedSpecificHour;

  @override
  void initState() {
    super.initState();
    _selectedSpecificDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleWeeklyDay(int day) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedWeeklyDays.contains(day)) {
        _selectedWeeklyDays.remove(day);
      } else {
        _selectedWeeklyDays.add(day);
      }
    });
  }

  Future<void> _addExamDate() async {
    HapticFeedback.lightImpact();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: OiyaStyles.primaryOnDark,
                    onPrimary: OiyaStyles.ink,
                    surface: OiyaStyles.surfaceTile1,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: OiyaStyles.primary,
                    onPrimary: Colors.white,
                    surface: OiyaStyles.canvas,
                    onSurface: OiyaStyles.ink,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        final normalized = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        if (!_selectedExamDates.any((d) => d.year == normalized.year && d.month == normalized.month && d.day == normalized.day)) {
          _selectedExamDates.add(normalized);
          _selectedExamDates.sort();
        }
      });
    }
  }

  Future<void> _pickSpecificDate() async {
    HapticFeedback.lightImpact();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedSpecificDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: OiyaStyles.primaryOnDark,
                    onPrimary: OiyaStyles.ink,
                    surface: OiyaStyles.surfaceTile1,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: OiyaStyles.primary,
                    onPrimary: Colors.white,
                    surface: OiyaStyles.canvas,
                    onSurface: OiyaStyles.ink,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedSpecificDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  Future<void> _pickSpecificHour() async {
    HapticFeedback.lightImpact();
    final pickedHour = await showCupertinoModalPopup<int>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          height: 250,
          color: isDark ? OiyaStyles.surfaceTile1 : Colors.white,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: isDark ? OiyaStyles.surfaceTile2 : Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx, _selectedSpecificHour ?? 9),
                        child: Text(
                          'Select',
                          style: OiyaStyles.captionStrong(
                            color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedSpecificHour ?? 9,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      _selectedSpecificHour = index;
                    },
                    children: List.generate(24, (index) {
                      return Center(
                        child: Text(
                          '${index.toString().padLeft(2, '0')}:00',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedHour != null) {
      setState(() {
        _selectedSpecificHour = pickedHour;
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    if (_scheduleType == 'custom' && _selectedWeeklyDays.isEmpty) {
      showOiyaToast(context, 'Please select at least one day.');
      return;
    }

    if (_scheduleType == 'exam' && _selectedExamDates.isEmpty) {
      showOiyaToast(context, 'Please add at least one exam date.');
      return;
    }

    if (_scheduleType == 'specific' && _selectedSpecificDate == null) {
      showOiyaToast(context, 'Please select a date.');
      return;
    }

    await ref.read(habitControllerProvider.notifier).addReminder(
          title: title,
          proofType: _proofType,
          scheduleType: _scheduleType,
          weeklyDays: _selectedWeeklyDays,
          examDates: _selectedExamDates,
          specificDate: _selectedSpecificDate,
          specificHour: _selectedSpecificHour,
        );

    if (mounted) {
      Navigator.pop(context);
      showOiyaToast(context, 'Habit created successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OiyaStyles.surfaceTile1 : OiyaStyles.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? const Color(0xFF333333) : OiyaStyles.hairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                'Create Habit / Study Schedule',
                style: OiyaStyles.tagline(color: isDark ? Colors.white : OiyaStyles.ink),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'HABIT / EXAM NAME',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: OiyaStyles.bodyText(color: isDark ? Colors.white : OiyaStyles.ink),
            decoration: InputDecoration(
              hintText: 'e.g. Maths Exam Prep, Clean the bed...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 15,
              ),
              filled: true,
              fillColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'VERIFICATION PROOF',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSegmentButton('none', 'No Photo Proof', _proofType == 'none', (val) {
                setState(() => _proofType = val);
              }),
              const SizedBox(width: 10),
              _buildSegmentButton('image', 'Polaroid Photo', _proofType == 'image', (val) {
                setState(() => _proofType = val);
              }),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'SCHEDULE TYPE',
            style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildScheduleSegment('daily', 'Daily', _scheduleType == 'daily'),
              const SizedBox(width: 8),
              _buildScheduleSegment('custom', 'Custom', _scheduleType == 'custom'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildScheduleSegment('exam', 'Exam Prep', _scheduleType == 'exam'),
              const SizedBox(width: 8),
              _buildScheduleSegment('specific', 'Activity Reminder', _scheduleType == 'specific'),
            ],
          ),
          const SizedBox(height: 20),
          if (_scheduleType == 'specific') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'REMINDER DATE & TIME',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date:',
                        style: OiyaStyles.bodyText(color: isDark ? Colors.white70 : OiyaStyles.ink),
                      ),
                      GestureDetector(
                        onTap: _pickSpecificDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? OiyaStyles.surfaceTile1 : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? Colors.white10 : OiyaStyles.dividerSoft,
                            ),
                          ),
                          child: Text(
                            _selectedSpecificDate != null
                                ? DateFormat('MMM dd, yyyy').format(_selectedSpecificDate!)
                                : 'Select Date',
                            style: OiyaStyles.captionStrong(
                              color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hour (Optional):',
                        style: OiyaStyles.bodyText(color: isDark ? Colors.white70 : OiyaStyles.ink),
                      ),
                      Row(
                        children: [
                          if (_selectedSpecificHour != null) ...[
                            GestureDetector(
                              onTap: () => setState(() => _selectedSpecificHour = null),
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  size: 18,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                          GestureDetector(
                            onTap: _pickSpecificHour,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? OiyaStyles.surfaceTile1 : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : OiyaStyles.dividerSoft,
                                ),
                              ),
                              child: Text(
                                _selectedSpecificHour != null
                                    ? '${_selectedSpecificHour!.toString().padLeft(2, '0')}:00'
                                    : 'All Day / None',
                                style: OiyaStyles.captionStrong(
                                  color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (_scheduleType == 'custom') ...[
            Text(
              'REPEAT DAYS',
              style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayNum = index + 1;
                final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                final isSelected = _selectedWeeklyDays.contains(dayNum);
                return GestureDetector(
                  onTap: () => _toggleWeeklyDay(dayNum),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                          : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                            : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dayName,
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? OiyaStyles.ink : Colors.white)
                            : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ] else if (_scheduleType == 'exam') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXAM DATES',
                  style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                ),
                GestureDetector(
                  onTap: _addExamDate,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.plus_circle, size: 14, color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Add Date',
                        style: OiyaStyles.captionStrong(color: isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedExamDates.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No exam dates added yet.',
                  style: OiyaStyles.caption(color: isDark ? OiyaStyles.bodyMuted : OiyaStyles.inkMuted80),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedExamDates.map((date) {
                  final dateStr = DateFormat('dd MMM yyyy').format(date);
                  return Chip(
                    label: Text(
                      dateStr,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : OiyaStyles.ink),
                    ),
                    backgroundColor: isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isDark ? Colors.white12 : OiyaStyles.dividerSoft),
                    ),
                    deleteIcon: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.redAccent),
                    onDeleted: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedExamDates.remove(date);
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x1F7CA982),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x407CA982)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.info_circle_fill, color: Color(0xFF7CA982), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Prep sessions will automatically be scheduled exactly 1 day before each exam date.',
                      style: OiyaStyles.finePrint(color: isDark ? Colors.white70 : OiyaStyles.inkMuted80),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            child: OiyaButton(
              label: 'Create Habit',
              isPrimary: true,
              onPressed: _save,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String value, String label, bool isSelected, ValueChanged<String> onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                  : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: OiyaStyles.captionStrong(
                color: isSelected
                    ? (isDark ? OiyaStyles.ink : Colors.white)
                    : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSegment(String value, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _scheduleType = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                : (isDark ? OiyaStyles.surfaceTile3 : OiyaStyles.surfacePearl),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? OiyaStyles.primaryOnDark : OiyaStyles.primary)
                  : (isDark ? Colors.white10 : OiyaStyles.dividerSoft),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: OiyaStyles.captionStrong(
                color: isSelected
                    ? (isDark ? OiyaStyles.ink : Colors.white)
                    : (isDark ? Colors.white70 : OiyaStyles.inkMuted80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
