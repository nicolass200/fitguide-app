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

  String? get primaryImageUrl {
    if (imageUrls.isEmpty) return null;
    return imageUrls.first;
  }

  String get cleanDescription {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final translations = json['translations'] as List<dynamic>? ?? [];

    Map<String, dynamic>? translation;

    for (final item in translations) {
      if (item is Map<String, dynamic>) {
        final itemName = item['name']?.toString().trim() ?? '';

        if (itemName.isNotEmpty) {
          translation = item;
          break;
        }
      }
    }

    final name = translation?['name']?.toString().trim();
    final description = translation?['description']?.toString().trim();

    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrls = images
        .whereType<Map<String, dynamic>>()
        .map((image) => image['image']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    final muscles = json['muscles'] as List<dynamic>? ?? [];
    final muscleIds = muscles.map((muscle) {
      if (muscle is int) return muscle;

      if (muscle is Map<String, dynamic>) {
        return muscle['id'] as int? ?? 0;
      }

      return 0;
    }).where((id) => id != 0).toList();

    final category = json['category'];

    int categoryId = 0;
    String categoryName = '';

    if (category is int) {
      categoryId = category;
    } else if (category is Map<String, dynamic>) {
      categoryId = category['id'] as int? ?? 0;
      categoryName = category['name']?.toString() ?? '';
    }

    return Exercise(
      id: json['id'] as int? ?? 0,
      name: name != null && name.isNotEmpty ? name : 'Exercício sem nome',
      description: description != null && description.isNotEmpty
          ? description
          : 'Descrição não disponível para este exercício.',
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrls: imageUrls,
      muscleIds: muscleIds,
    );
  }
}