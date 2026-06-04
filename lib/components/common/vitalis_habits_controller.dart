import 'package:flutter/material.dart';

enum VitalisHabit {
  hydration,
  sleep,
  movement,
  mood,
  gym,
  swimming,
  reading,
  fasting,
  extraNotifications,
  religious,
  drawingPainting,
  languages,
  medicineTime,
  studies,
  climbing,
  music,
  trail,
  socialActivities,
  martialArts,
  dance,
  financialGoals,
  travel,
  cycling,
}

enum VitalisMoodGoalMethod {
  manterCalma,
  aumentarEnergia,
  reduzirAnsiedade,
}

class VitalisHabitsController extends ChangeNotifier {
  final Set<VitalisHabit> _habits = {};
  int? _hydrationGoalMl;
  int _hydrationConsumedMl = 0;
  int? _sleepGoalMinutes;
  int _sleepMinutes = 0;
  int? _movementGoalMeters;
  int _movementMeters = 0;
  final Set<int> _movementDaysOfWeek = {};
  int? _moodLastWeekLevel;
  int? _moodTargetLevel;
  VitalisMoodGoalMethod? _moodGoalMethod;

  Set<VitalisHabit> get habits => Set.unmodifiable(_habits);

  bool get hasHabits => _habits.isNotEmpty;

  int? get hydrationGoalMl => _hydrationGoalMl;

  int get hydrationConsumedMl => _hydrationConsumedMl;

  int? get sleepGoalMinutes => _sleepGoalMinutes;

  int get sleepMinutes => _sleepMinutes;

  int? get movementGoalMeters => _movementGoalMeters;

  int get movementMeters => _movementMeters;

  Set<int> get movementDaysOfWeek => Set.unmodifiable(_movementDaysOfWeek);

  int? get moodLastWeekLevel => _moodLastWeekLevel;

  int? get moodTargetLevel => _moodTargetLevel;

  VitalisMoodGoalMethod? get moodGoalMethod => _moodGoalMethod;

  void setHydrationGoalMl(int goalMl) {
    if (goalMl <= 0) return;
    _hydrationGoalMl = goalMl;
    if (_hydrationConsumedMl > goalMl) {
      _hydrationConsumedMl = goalMl;
    }
    notifyListeners();
  }

  void setHydrationConsumedMl(int consumedMl) {
    final goal = _hydrationGoalMl;
    final clamped = consumedMl < 0 ? 0 : consumedMl;
    _hydrationConsumedMl = goal == null ? clamped : clamped.clamp(0, goal);
    notifyListeners();
  }

  void addHydrationMl(int ml) {
    if (ml == 0) return;
    setHydrationConsumedMl(_hydrationConsumedMl + ml);
  }

  void setSleepGoalMinutes(int goalMinutes) {
    if (goalMinutes <= 0) return;
    _sleepGoalMinutes = goalMinutes;
    if (_sleepMinutes > goalMinutes) {
      _sleepMinutes = goalMinutes;
    }
    notifyListeners();
  }

  void setSleepMinutes(int minutes) {
    final goal = _sleepGoalMinutes;
    final clamped = minutes < 0 ? 0 : minutes;
    _sleepMinutes = goal == null ? clamped : clamped.clamp(0, goal);
    notifyListeners();
  }

  void addSleepMinutes(int minutes) {
    if (minutes == 0) return;
    setSleepMinutes(_sleepMinutes + minutes);
  }

  void setMovementGoalMeters(int goalMeters) {
    if (goalMeters <= 0) return;
    _movementGoalMeters = goalMeters;
    if (_movementMeters > goalMeters) {
      _movementMeters = goalMeters;
    }
    notifyListeners();
  }

  void setMovementMeters(int meters) {
    final goal = _movementGoalMeters;
    final clamped = meters < 0 ? 0 : meters;
    _movementMeters = goal == null ? clamped : clamped.clamp(0, goal);
    notifyListeners();
  }

  void addMovementMeters(int meters) {
    if (meters == 0) return;
    setMovementMeters(_movementMeters + meters);
  }

  void setMovementDaysOfWeek(Set<int> daysOfWeek) {
    final normalized = daysOfWeek.where((d) => d >= 1 && d <= 7).toSet();
    _movementDaysOfWeek
      ..clear()
      ..addAll(normalized);
    notifyListeners();
  }

  void setMoodPlan({
    required int lastWeekLevel,
    required VitalisMoodGoalMethod method,
  }) {
    final clampedLast = lastWeekLevel.clamp(0, 4);
    final target = _calculateMoodTarget(lastWeekLevel: clampedLast, method: method);
    _moodLastWeekLevel = clampedLast;
    _moodGoalMethod = method;
    _moodTargetLevel = target;
    notifyListeners();
  }

  int _calculateMoodTarget({
    required int lastWeekLevel,
    required VitalisMoodGoalMethod method,
  }) {
    if (lastWeekLevel <= 0) return 0;
    return switch (method) {
      VitalisMoodGoalMethod.aumentarEnergia => 0,
      VitalisMoodGoalMethod.manterCalma => (lastWeekLevel - 1).clamp(0, 4),
      VitalisMoodGoalMethod.reduzirAnsiedade => (lastWeekLevel - 2).clamp(0, 4),
    };
  }

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
