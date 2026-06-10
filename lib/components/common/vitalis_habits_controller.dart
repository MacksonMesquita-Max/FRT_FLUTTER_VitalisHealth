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

enum VitalisGymIntensity {
  leve,
  moderada,
  intensa,
}

enum VitalisGymFocus {
  forca,
  cardio,
  flexibilidade,
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
  int? _swimmingGoalMeters;
  int _swimmingMeters = 0;
  final Set<int> _swimmingDaysOfWeek = {};
  int? _moodLastWeekLevel;
  int? _moodTargetLevel;
  VitalisMoodGoalMethod? _moodGoalMethod;
  int? _gymDurationMinutes;
  VitalisGymIntensity? _gymIntensity;
  VitalisGymFocus? _gymFocus;
  final Set<int> _gymDaysOfWeek = {};
  String? _readingBookName;
  int? _readingPageGoal;
  final Set<int> _readingDaysOfWeek = {};
  String? _fastingPurpose;
  int? _fastingDurationHours;
  String? _extraNotificationsTitle;
  int? _extraNotificationsDurationMinutes;
  final Set<int> _extraNotificationsDaysOfWeek = {};
  int? _extraNotificationsReminderMinutes;
  String? _extraNotificationsSubject;
  String? _extraNotificationsIconKey;
  String? _religiousPracticeName;
  int? _religiousDurationMinutes;
  final Set<int> _religiousDaysOfWeek = {};
  int? _religiousReminderMinutes;
  String? _languagesName;
  int? _languagesStudyMinutes;
  final Set<int> _languagesDaysOfWeek = {};
  int? _languagesReminderMinutes;
  String? _drawingPaintingTechnique;
  int? _drawingPaintingDurationMinutes;
  final Set<int> _drawingPaintingDaysOfWeek = {};
  int? _drawingPaintingReminderMinutes;

  Set<VitalisHabit> get habits => Set.unmodifiable(_habits);

  bool get hasHabits => _habits.isNotEmpty;

  int? get hydrationGoalMl => _hydrationGoalMl;

  int get hydrationConsumedMl => _hydrationConsumedMl;

  int? get sleepGoalMinutes => _sleepGoalMinutes;

  int get sleepMinutes => _sleepMinutes;

  int? get movementGoalMeters => _movementGoalMeters;

  int get movementMeters => _movementMeters;

  Set<int> get movementDaysOfWeek => Set.unmodifiable(_movementDaysOfWeek);

  int? get swimmingGoalMeters => _swimmingGoalMeters;

  int get swimmingMeters => _swimmingMeters;

  Set<int> get swimmingDaysOfWeek => Set.unmodifiable(_swimmingDaysOfWeek);

  int? get moodLastWeekLevel => _moodLastWeekLevel;

  int? get moodTargetLevel => _moodTargetLevel;

  VitalisMoodGoalMethod? get moodGoalMethod => _moodGoalMethod;

  int? get gymDurationMinutes => _gymDurationMinutes;

  VitalisGymIntensity? get gymIntensity => _gymIntensity;

  VitalisGymFocus? get gymFocus => _gymFocus;

  Set<int> get gymDaysOfWeek => Set.unmodifiable(_gymDaysOfWeek);

  String? get readingBookName => _readingBookName;

  int? get readingPageGoal => _readingPageGoal;

  Set<int> get readingDaysOfWeek => Set.unmodifiable(_readingDaysOfWeek);

  String? get fastingPurpose => _fastingPurpose;

  int? get fastingDurationHours => _fastingDurationHours;

  String? get extraNotificationsTitle => _extraNotificationsTitle;

  int? get extraNotificationsDurationMinutes => _extraNotificationsDurationMinutes;

  Set<int> get extraNotificationsDaysOfWeek =>
      Set.unmodifiable(_extraNotificationsDaysOfWeek);

  int? get extraNotificationsReminderMinutes =>
      _extraNotificationsReminderMinutes;

  String? get extraNotificationsSubject => _extraNotificationsSubject;

  String? get extraNotificationsIconKey => _extraNotificationsIconKey;

  String? get religiousPracticeName => _religiousPracticeName;

  int? get religiousDurationMinutes => _religiousDurationMinutes;

  Set<int> get religiousDaysOfWeek => Set.unmodifiable(_religiousDaysOfWeek);

  int? get religiousReminderMinutes => _religiousReminderMinutes;

  String? get languagesName => _languagesName;

  int? get languagesStudyMinutes => _languagesStudyMinutes;

  Set<int> get languagesDaysOfWeek => Set.unmodifiable(_languagesDaysOfWeek);

  int? get languagesReminderMinutes => _languagesReminderMinutes;

  String? get drawingPaintingTechnique => _drawingPaintingTechnique;

  int? get drawingPaintingDurationMinutes => _drawingPaintingDurationMinutes;

  Set<int> get drawingPaintingDaysOfWeek =>
      Set.unmodifiable(_drawingPaintingDaysOfWeek);

  int? get drawingPaintingReminderMinutes =>
      _drawingPaintingReminderMinutes;

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

  void setSwimmingGoalMeters(int goalMeters) {
    if (goalMeters <= 0) return;
    _swimmingGoalMeters = goalMeters;
    if (_swimmingMeters > goalMeters) {
      _swimmingMeters = goalMeters;
    }
    notifyListeners();
  }

  void setSwimmingMeters(int meters) {
    final goal = _swimmingGoalMeters;
    final clamped = meters < 0 ? 0 : meters;
    _swimmingMeters = goal == null ? clamped : clamped.clamp(0, goal);
    notifyListeners();
  }

  void addSwimmingMeters(int meters) {
    if (meters == 0) return;
    setSwimmingMeters(_swimmingMeters + meters);
  }

  void setSwimmingDaysOfWeek(Set<int> daysOfWeek) {
    final normalized = daysOfWeek.where((d) => d >= 1 && d <= 7).toSet();
    _swimmingDaysOfWeek
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

  void setGymPlan({
    required int durationMinutes,
    required VitalisGymIntensity intensity,
    required VitalisGymFocus focus,
    required Set<int> daysOfWeek,
  }) {
    _gymDurationMinutes = durationMinutes.clamp(15, 120);
    _gymIntensity = intensity;
    _gymFocus = focus;
    _gymDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    notifyListeners();
  }

  void setReadingPlan({
    required String bookName,
    required int pageGoal,
    required Set<int> daysOfWeek,
  }) {
    final normalizedBookName = bookName.trim();
    if (normalizedBookName.isEmpty || pageGoal <= 0) return;
    _readingBookName = normalizedBookName;
    _readingPageGoal = pageGoal;
    _readingDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    notifyListeners();
  }

  void setFastingPlan({
    required String purpose,
    required int durationHours,
  }) {
    final normalizedPurpose = purpose.trim();
    if (normalizedPurpose.isEmpty || durationHours < 0) return;
    _fastingPurpose = normalizedPurpose;
    _fastingDurationHours = durationHours.clamp(0, 24);
    notifyListeners();
  }

  void setExtraNotificationsPlan({
    required String title,
    required int durationMinutes,
    required Set<int> daysOfWeek,
    required int reminderMinutes,
    required String subject,
    required String iconKey,
  }) {
    final normalizedTitle = title.trim();
    final normalizedSubject = subject.trim();
    final normalizedIconKey = iconKey.trim();
    if (normalizedTitle.isEmpty ||
        normalizedSubject.isEmpty ||
        normalizedIconKey.isEmpty ||
        durationMinutes <= 0) {
      return;
    }

    _extraNotificationsTitle = normalizedTitle;
    _extraNotificationsDurationMinutes = durationMinutes.clamp(1, 180);
    _extraNotificationsDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    _extraNotificationsReminderMinutes = reminderMinutes.clamp(0, 1439);
    _extraNotificationsSubject = normalizedSubject;
    _extraNotificationsIconKey = normalizedIconKey;
    notifyListeners();
  }

  void setReligiousPlan({
    required String practiceName,
    required int durationMinutes,
    required Set<int> daysOfWeek,
    required int reminderMinutes,
  }) {
    final normalizedPracticeName = practiceName.trim();
    if (normalizedPracticeName.isEmpty || durationMinutes <= 0) return;

    _religiousPracticeName = normalizedPracticeName;
    _religiousDurationMinutes = durationMinutes.clamp(1, 180);
    _religiousDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    _religiousReminderMinutes = reminderMinutes.clamp(0, 1439);
    notifyListeners();
  }

  void setLanguagesPlan({
    required String languageName,
    required int studyMinutes,
    required Set<int> daysOfWeek,
    required int reminderMinutes,
  }) {
    final normalizedLanguageName = languageName.trim();
    if (normalizedLanguageName.isEmpty || studyMinutes <= 0) return;

    _languagesName = normalizedLanguageName;
    _languagesStudyMinutes = studyMinutes.clamp(1, 180);
    _languagesDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    _languagesReminderMinutes = reminderMinutes.clamp(0, 1439);
    notifyListeners();
  }

  void setDrawingPaintingPlan({
    required String technique,
    required int durationMinutes,
    required Set<int> daysOfWeek,
    required int reminderMinutes,
  }) {
    final normalizedTechnique = technique.trim();
    if (normalizedTechnique.isEmpty || durationMinutes <= 0) return;

    _drawingPaintingTechnique = normalizedTechnique;
    _drawingPaintingDurationMinutes = durationMinutes.clamp(1, 180);
    _drawingPaintingDaysOfWeek
      ..clear()
      ..addAll(daysOfWeek.where((d) => d >= 1 && d <= 7));
    _drawingPaintingReminderMinutes = reminderMinutes.clamp(0, 1439);
    notifyListeners();
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
