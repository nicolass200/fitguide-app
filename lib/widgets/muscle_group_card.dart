// lib/widgets/muscle_group_card.dart

import 'package:flutter/material.dart';
import '../models/muscle_group.dart';
import '../core/theme/app_theme.dart';

class MuscleGroupCard extends StatelessWidget {
  final MuscleGroup muscleGroup;
  final bool isCompact;
  final VoidCallback onTap;

  const MuscleGroupCard({
    super.key,
    required this.muscleGroup,
    required this.isCompact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryDark,
              ],
            ),
          ),
          child: isCompact ? _buildCompactLayout() : _buildFullLayout(),
        ),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForMuscleGroup(muscleGroup.nameEn),
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            muscleGroup.nameEn,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForMuscleGroup(muscleGroup.nameEn),
            size: 28,
            color: Colors.white,
          ),
          const SizedBox(height: 6),
          Text(
            muscleGroup.nameEn,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForMuscleGroup(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('chest') || lowerName.contains('peit')) return Icons.accessibility_new;
    if (lowerName.contains('back') || lowerName.contains('cost')) return Icons.airline_seat_flat;
    if (lowerName.contains('shoulder') || lowerName.contains('ombro')) return Icons.sports_handball;
    if (lowerName.contains('arm') || lowerName.contains('bra')) return Icons.sports_martial_arts;
    if (lowerName.contains('leg') || lowerName.contains('perna')) return Icons.directions_walk;
    if (lowerName.contains('abs') || lowerName.contains('abd')) return Icons.self_improvement;
    if (lowerName.contains('glute') || lowerName.contains('glut')) return Icons.airline_seat_recline_normal;
    return Icons.fitness_center;
  }
}
