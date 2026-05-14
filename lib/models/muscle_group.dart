class MuscleGroup {
  final int id;
  final String name;
  final String nameEn;

  const MuscleGroup({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  factory MuscleGroup.fromJson(Map<String, dynamic> json) {
    final englishName = json['name']?.toString() ?? '';

    return MuscleGroup(
      id: json['id'] as int? ?? 0,
      name: translateName(englishName),
      nameEn: englishName,
    );
  }

  static List<MuscleGroup> defaultGroups() {
    return const [
      MuscleGroup(id: 10, name: 'Abdômen', nameEn: 'Abs'),
      MuscleGroup(id: 8, name: 'Braços', nameEn: 'Arms'),
      MuscleGroup(id: 12, name: 'Costas', nameEn: 'Back'),
      MuscleGroup(id: 14, name: 'Panturrilhas', nameEn: 'Calves'),
      MuscleGroup(id: 15, name: 'Cardio', nameEn: 'Cardio'),
      MuscleGroup(id: 11, name: 'Peito', nameEn: 'Chest'),
      MuscleGroup(id: 9, name: 'Pernas', nameEn: 'Legs'),
      MuscleGroup(id: 13, name: 'Ombros', nameEn: 'Shoulders'),
    ];
  }

  static String translateName(String name) {
    switch (name.toLowerCase()) {
      case 'abs':
      case 'waist':
        return 'Abdômen';
      case 'arms':
      case 'upper arms':
        return 'Braços';
      case 'back':
        return 'Costas';
      case 'calves':
      case 'lower legs':
        return 'Panturrilhas';
      case 'cardio':
        return 'Cardio';
      case 'chest':
        return 'Peito';
      case 'legs':
      case 'upper legs':
        return 'Pernas';
      case 'shoulders':
        return 'Ombros';
      default:
        return name;
    }
  }
}