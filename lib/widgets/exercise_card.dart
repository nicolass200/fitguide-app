import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../core/theme/app_theme.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isCompact;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.isCompact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: isCompact ? _buildCompactLayout() : _buildFullLayout(),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildThumbnail(size: 72),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                if (exercise.cleanDescription.isNotEmpty)
                  Text(
                    exercise.cleanDescription,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.fitness_center,
            color: AppTheme.primaryColor,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildThumbnail({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.fitness_center,
        color: AppTheme.primaryColor,
        size: 30,
      ),
    );
  }
}