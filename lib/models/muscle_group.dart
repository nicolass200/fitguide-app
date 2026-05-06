// lib/models/muscle_group.dart

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
    final id = json['id'] as int;
    final nameEn = json['name'] as String? ?? 'Grupo muscular';

    return MuscleGroup(
      id: id,
      name: _translateCategory(id, nameEn),
      nameEn: nameEn,
    );
  }

  static String _translateCategory(int id, String fallback) {
    const names = {
      8: 'Braços',
      9: 'Pernas',
      10: 'Abdômen',
      11: 'Peito',
      12: 'Costas',
      13: 'Ombros',
      14: 'Panturrilhas',
      15: 'Cardio',
    };

    return names[id] ?? fallback;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
    };
  }
}
