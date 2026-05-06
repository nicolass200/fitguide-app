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

  static String translateName(String name) {
    switch (name.toLowerCase()) {
      case 'abs':
        return 'Abdômen';
      case 'arms':
        return 'Braços';
      case 'back':
        return 'Costas';
      case 'calves':
        return 'Panturrilhas';
      case 'cardio':
        return 'Cardio';
      case 'chest':
        return 'Peito';
      case 'legs':
        return 'Pernas';
      case 'shoulders':
        return 'Ombros';
      default:
        return name;
    }
  }
}