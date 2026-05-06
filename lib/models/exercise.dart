// lib/models/exercise.dart

class Exercise {
  final int id;
  final String name;
  final String description;
  final int categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final List<int> muscleIds;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.muscleIds,
  });

  /// Retorna a primeira imagem disponível ou null
  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Retorna descrição sem tags HTML
  String get cleanDescription {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .trim();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final translations = json['translations'] as List<dynamic>? ?? [];

    Map<String, dynamic>? selectedTranslation;
    for (final item in translations) {
      if (item is Map<String, dynamic> && item['language'] == 2) {
        selectedTranslation = item;
        break;
      }
    }
    selectedTranslation ??= translations.whereType<Map<String, dynamic>>().isNotEmpty
        ? translations.whereType<Map<String, dynamic>>().first
        : null;

    final categoryValue = json['category'];
    int categoryId = 0;
    String categoryName = '';

    if (categoryValue is Map<String, dynamic>) {
      categoryId = _toInt(categoryValue['id']);
      categoryName = categoryValue['name']?.toString() ?? '';
    } else {
      categoryId = _toInt(categoryValue);
    }

    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrls = images
        .map((img) {
          if (img is String) return img;
          if (img is Map<String, dynamic>) return img['image']?.toString() ?? '';
          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();

    final muscles = json['muscles'] as List<dynamic>? ?? [];
    final muscleIds = muscles
        .map((m) {
          if (m is int) return m;
          if (m is Map<String, dynamic>) return _toInt(m['id']);
          return 0;
        })
        .where((id) => id > 0)
        .toList();

    return Exercise(
      id: _toInt(json['id']),
      name: selectedTranslation?['name']?.toString() ??
          json['name']?.toString() ??
          'Exercício sem nome',
      description: selectedTranslation?['description']?.toString() ??
          json['description']?.toString() ??
          '',
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrls: imageUrls,
      muscleIds: muscleIds,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
