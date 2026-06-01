import 'package:flutter/material.dart';

enum VitalisHabit {
  hydration,
  sleep,
  movement,
  mood,
}

class VitalisHabitsController extends ChangeNotifier {
  final Set<VitalisHabit> _habits = {};

  Set<VitalisHabit> get habits => Set.unmodifiable(_habits);

  bool get hasHabits => _habits.isNotEmpty;

  void addAll(Iterable<VitalisHabit> habits) {
    final before = _habits.length;
    _habits.addAll(habits);
    if (_habits.length != before) notifyListeners();
  }
}

class VitalisHabitsScope extends InheritedNotifier<VitalisHabitsController> {
  const VitalisHabitsScope({
    super.key,
    required VitalisHabitsController controller,
    required super.child,
  }) : super(notifier: controller);

  static VitalisHabitsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<VitalisHabitsScope>();
    if (scope == null) {
      throw FlutterError('VitalisHabitsScope not found in widget tree.');
    }
    return scope.notifier!;
  }
}
