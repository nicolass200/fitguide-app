// lib/models/exercise.dart

class Exercise {
  final int id;
  final String name;
  final String description;
  final int categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final List<int> muscleIds;

  // Campos próprios da WorkoutX
  final String apiId;
  final String bodyPart;
  final String target;
  final String equipment;
  final List<String> instructions;
  final List<String> secondaryMuscles;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.muscleIds,
    this.apiId = '',
    this.bodyPart = '',
    this.target = '',
    this.equipment = '',
    this.instructions = const [],
    this.secondaryMuscles = const [],
  });

  String? get primaryImageUrl {
    if (imageUrls.isEmpty) return null;
    return imageUrls.first;
  }

  String get cleanDescription {
    if (instructions.isNotEmpty) {
      return instructions
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .join('\n\n');
    }

    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final apiId = json['id']?.toString().trim() ?? '';
    final name = json['name']?.toString().trim() ?? '';
    final bodyPart = json['bodyPart']?.toString().trim() ?? '';
    final target = json['target']?.toString().trim() ?? '';
    final equipment = json['equipment']?.toString().trim() ?? '';
    final gifUrl = json['gifUrl']?.toString().trim() ?? '';

    final instructions = _stringListFromJson(json['instructions']);
    final secondaryMuscles = _stringListFromJson(json['secondaryMuscles']);

    final description = instructions.isNotEmpty
        ? instructions.join('\n\n')
        : 'Descrição não disponível para este exercício.';

    return Exercise(
      id: _stableIdFromString(apiId.isNotEmpty ? apiId : name),
      apiId: apiId,
      name: name.isNotEmpty ? _capitalizeWords(name) : 'Exercício sem nome',
      description: description,
      categoryId: _categoryIdFromBodyPart(bodyPart),
      categoryName: _translateBodyPart(bodyPart),
      imageUrls: gifUrl.isNotEmpty ? [gifUrl] : [],
      muscleIds: const [],
      bodyPart: bodyPart,
      target: target,
      equipment: equipment,
      instructions: instructions,
      secondaryMuscles: secondaryMuscles,
    );
  }

  static List<String> _stringListFromJson(dynamic value) {
    if (value is! List) return [];

    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty && item != 'null')
        .toList();
  }

  static String _capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  static int _stableIdFromString(String value) {
    var hash = 0;

    for (final codeUnit in value.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }

    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));

    return hash.abs();
  }

  static int _categoryIdFromBodyPart(String bodyPart) {
    switch (bodyPart.toLowerCase()) {
      case 'waist':
        return 10;
      case 'upper arms':
        return 8;
      case 'back':
        return 12;
      case 'lower legs':
        return 14;
      case 'cardio':
        return 15;
      case 'chest':
        return 11;
      case 'upper legs':
        return 9;
      case 'shoulders':
        return 13;
      default:
        return 0;
    }
  }

  static String _translateBodyPart(String bodyPart) {
    switch (bodyPart.toLowerCase()) {
      case 'waist':
        return 'Abdômen';
      case 'upper arms':
        return 'Braços';
      case 'back':
        return 'Costas';
      case 'lower legs':
        return 'Panturrilhas';
      case 'cardio':
        return 'Cardio';
      case 'chest':
        return 'Peito';
      case 'upper legs':
        return 'Pernas';
      case 'shoulders':
        return 'Ombros';
      default:
        return bodyPart;
    }
  }
}