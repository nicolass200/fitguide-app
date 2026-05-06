// lib/screens/exercise_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/preferences_provider.dart';
import '../models/muscle_group.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import '../widgets/error_state_widget.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final MuscleGroup muscleGroup;

  const ExerciseListScreen({super.key, required this.muscleGroup});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ExerciseProvider>()
          .loadExercisesByCategory(widget.muscleGroup.id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.muscleGroup.name),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildExerciseList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar exercício...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ExerciseProvider>().filterExercises('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          context.read<ExerciseProvider>().filterExercises(value);
          setState(() {}); // Atualiza o ícone de limpar
        },
      ),
    );
  }

  Widget _buildExerciseList() {
    return Consumer2<ExerciseProvider, PreferencesProvider>(
      builder: (context, exerciseProvider, prefsProvider, _) {
        if (exerciseProvider.isExercisesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (exerciseProvider.exercisesState == LoadingState.error) {
          return ErrorStateWidget(
            message: exerciseProvider.exercisesError,
            onRetry: () => exerciseProvider
                .loadExercisesByCategory(widget.muscleGroup.id),
          );
        }

        final exercises = exerciseProvider.exercises;

        if (exercises.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ExerciseCard(
              exercise: exercises[index],
              isCompact: prefsProvider.compactMode,
              onTap: () => _navigateToDetail(exercises[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'Nenhum exercício encontrado para\n"${_searchController.text}"'
                : 'Nenhum exercício disponível.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(exercise: exercise),
      ),
    );
  }
}
