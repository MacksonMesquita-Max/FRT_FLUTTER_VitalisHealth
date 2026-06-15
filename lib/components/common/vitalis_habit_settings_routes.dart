import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/vitalis_habits_controller.dart';
import 'package:vitalis_app/components/screens/habits_settings/climbing_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/cycling_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/dance_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/drawing_painting_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/fasting_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/financial_goals_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/gym_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/hydration_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/languages_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/martial_arts_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/medicine_time_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/mood_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/movement_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/music_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/notifications_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/reading_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/religious_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/sleep_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/social_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/studies_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/swimming_habit_settings_screen.dart';
import 'package:vitalis_app/components/screens/habits_settings/travel_habit_settings_screen.dart';

Route<bool> createVitalisHabitSettingsRoute(VitalisHabit habit) {
  return MaterialPageRoute<bool>(
    builder: (_) {
      switch (habit) {
        case VitalisHabit.hydration:
          return const HydrationHabitSettingsScreen();
        case VitalisHabit.sleep:
          return const SleepHabitSettingsScreen();
        case VitalisHabit.movement:
          return const MovementHabitSettingsScreen();
        case VitalisHabit.mood:
          return const MoodHabitSettingsScreen();
        case VitalisHabit.gym:
          return const GymHabitSettingsScreen();
        case VitalisHabit.swimming:
          return const SwimmingHabitSettingsScreen();
        case VitalisHabit.reading:
          return const ReadingHabitSettingsScreen();
        case VitalisHabit.fasting:
          return const FastingHabitSettingsScreen();
        case VitalisHabit.extraNotifications:
          return const NotificationsHabitSettingsScreen();
        case VitalisHabit.religious:
          return const ReligiousHabitSettingsScreen();
        case VitalisHabit.drawingPainting:
          return const DrawingPaintingHabitSettingsScreen();
        case VitalisHabit.languages:
          return const LanguagesHabitSettingsScreen();
        case VitalisHabit.medicineTime:
          return const MedicineTimeHabitSettingsScreen();
        case VitalisHabit.studies:
          return const StudiesHabitSettingsScreen();
        case VitalisHabit.climbing:
          return const ClimbingHabitSettingsScreen();
        case VitalisHabit.music:
          return const MusicHabitSettingsScreen();
        case VitalisHabit.socialActivities:
          return const SocialHabitSettingsScreen();
        case VitalisHabit.martialArts:
          return const MartialArtsHabitSettingsScreen();
        case VitalisHabit.dance:
          return const DanceHabitSettingsScreen();
        case VitalisHabit.financialGoals:
          return const FinancialGoalsHabitSettingsScreen();
        case VitalisHabit.travel:
          return const TravelHabitSettingsScreen();
        case VitalisHabit.cycling:
          return const CyclingHabitSettingsScreen();
      }
    },
  );
}
