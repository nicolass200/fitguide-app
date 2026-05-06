// lib/screens/exercise_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../widgets/rest_timer_widget.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _selectedSeries = 3;
  bool _addToWorkout = false;
  final TextEditingController _workoutNameController = TextEditingController();

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseImage(exercise),
            const SizedBox(height: 20),
            _buildExerciseName(exercise),
            const SizedBox(height: 16),
            _buildDescription(exercise),
            const SizedBox(height: 24),
            _buildSeriesSlider(),
            const SizedBox(height: 16),
            _buildAddToWorkoutSection(),
            const SizedBox(height: 24),
            const RestTimerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseImage(Exercise exercise) {
    if (exercise.primaryImageUrl == null) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        exercise.primaryImageUrl!,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 220,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 220,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildExerciseName(Exercise exercise) {
    return Text(
      exercise.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildDescription(Exercise exercise) {
    final description = exercise.cleanDescription;

    if (description.isEmpty) {
      return const Text(
        'Descrição não disponível para este exercício.',
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Como executar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Número de séries',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_selectedSeries',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _selectedSeries.toDouble(),
              min: AppConstants.minSeries.toDouble(),
              max: AppConstants.maxSeries.toDouble(),
              divisions: AppConstants.maxSeries - AppConstants.minSeries,
              label: '$_selectedSeries séries',
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() => _selectedSeries = value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                AppConstants.maxSeries,
                (i) => Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _selectedSeries == i + 1
                        ? AppTheme.primaryColor
                        : Colors.grey,
                    fontWeight: _selectedSeries == i + 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToWorkoutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox para adicionar ao treino
            Row(
              children: [
                Checkbox(
                  value: _addToWorkout,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() => _addToWorkout = value ?? false);
                  },
                ),
                const Expanded(
                  child: Text(
                    'Adicionar ao novo treino',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            // Campo de nome do treino — aparece apenas quando o checkbox está marcado
            if (_addToWorkout) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _workoutNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do treino',
                  hintText: 'Ex: Treino A - Peito e Tríceps',
                  prefixIcon: Icon(Icons.edit),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Treino'),
                  onPressed: _saveWorkout,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveWorkout() async {
    final workoutName = _workoutNameController.text.trim();

    if (workoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um nome para o treino.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final workoutExercise = WorkoutExercise(
      workoutId: 0, // Será atribuído pelo banco
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      series: _selectedSeries,
    );

    final success = await context
        .read<WorkoutProvider>()
        .createWorkout(workoutName, [workoutExercise]);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treino salvo com sucesso! ✅'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      setState(() {
        _addToWorkout = false;
        _workoutNameController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar treino. Tente novamente.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
