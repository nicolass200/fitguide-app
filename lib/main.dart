import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/exercise_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/preferences_provider.dart';
import 'services/workoutx_api_service.dart';
import 'services/workout_database_service.dart';
import 'services/preferences_service.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FitGuideApp());
}

class FitGuideApp extends StatelessWidget {
  const FitGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WorkoutXApiService>(create: (_) => WorkoutXApiService()),
        Provider<WorkoutDatabaseService>(create: (_) => WorkoutDatabaseService()),
        Provider<PreferencesService>(create: (_) => PreferencesService()),
        ChangeNotifierProvider<ExerciseProvider>(
          create: (context) => ExerciseProvider(
            context.read<WorkoutXApiService>(),
          ),
        ),
        ChangeNotifierProvider<WorkoutProvider>(
          create: (context) => WorkoutProvider(
            context.read<WorkoutDatabaseService>(),
          ),
        ),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (context) => PreferencesProvider(
            context.read<PreferencesService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'FitGuide',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
