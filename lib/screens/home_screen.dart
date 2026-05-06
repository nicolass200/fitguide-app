// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/preferences_provider.dart';
import '../models/muscle_group.dart';
import '../widgets/muscle_group_card.dart';
import '../widgets/error_state_widget.dart';
import 'exercise_list_screen.dart';
import 'my_workouts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega dados logo após o primeiro frame renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().loadMuscleGroups();
      context.read<PreferencesProvider>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitGuide'),
        actions: [
          // Switch de modo compacto
          Consumer<PreferencesProvider>(
            builder: (context, prefs, _) {
              return Row(
                children: [
                  const Icon(Icons.view_compact, size: 18),
                  Switch(
                    value: prefs.compactMode,
                    onChanged: prefs.toggleCompactMode,
                    activeColor: Colors.white,
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fitness_center),
            tooltip: 'Meus Treinos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyWorkoutsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, _) {
          if (provider.isMuscleGroupsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.muscleGroupsState == LoadingState.error) {
            return ErrorStateWidget(
              message: provider.muscleGroupsError,
              onRetry: provider.loadMuscleGroups,
            );
          }

          return Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMuscleGroupGrid(provider.muscleGroups)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      color: const Color(0xFF1E88E5),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qual grupo muscular\nvocê quer treinar hoje?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Selecione um grupo para ver os exercícios',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupGrid(List<MuscleGroup> groups) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: prefs.compactMode ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: prefs.compactMode ? 1.0 : 1.2,
          ),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return MuscleGroupCard(
              muscleGroup: groups[index],
              isCompact: prefs.compactMode,
              onTap: () => _navigateToExercises(groups[index]),
            );
          },
        );
      },
    );
  }

  void _navigateToExercises(MuscleGroup muscleGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseListScreen(muscleGroup: muscleGroup),
      ),
    );
  }
}
