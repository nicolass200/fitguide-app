// lib/screens/my_workouts_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import '../core/theme/app_theme.dart';
import '../widgets/error_state_widget.dart';

class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Treinos')),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return ErrorStateWidget(
              message: provider.errorMessage,
              onRetry: provider.loadWorkouts,
            );
          }

          if (provider.workouts.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.workouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _WorkoutCard(workout: provider.workouts[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhum treino salvo ainda.',
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Acesse um exercício e crie seu treino!',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Icon(Icons.fitness_center, color: Colors.white, size: 20),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${workout.exercises.length} exercício(s) · ${_formatDate(workout.createdAt)}',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              tooltip: 'Renomear',
              onPressed: () => _showRenameDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.errorColor),
              tooltip: 'Excluir',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        children: workout.exercises.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhum exercício neste treino.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ]
            : workout.exercises.map((exercise) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: const Icon(Icons.arrow_right, color: AppTheme.primaryColor),
                  title: Text(exercise.exerciseName),
                  subtitle: Text('${exercise.series} séries'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => context
                        .read<WorkoutProvider>()
                        .removeExerciseFromWorkout(exercise.id!),
                  ),
                );
              }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: workout.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Renomear Treino'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Novo nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<WorkoutProvider>()
                  .renameWorkout(workout.id!, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Treino'),
        content: Text('Deseja excluir "${workout.name}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () {
              context.read<WorkoutProvider>().deleteWorkout(workout.id!);
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
