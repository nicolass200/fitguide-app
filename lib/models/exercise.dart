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
        .replaceAll('\n\n\n', '\n\n')
        .trim();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final translation = _selectBestTranslation(json['translations']);

    final directName = json['name']?.toString().trim() ?? '';
    final directDescription = json['description']?.toString().trim() ?? '';

    final translatedName = translation?['name']?.toString().trim() ?? '';
    final translatedDescription =
        translation?['description']?.toString().trim() ?? '';

    final name = translatedName.isNotEmpty ? translatedName : directName;

    final description = translatedDescription.isNotEmpty
        ? translatedDescription
        : directDescription;

    final imageUrls = _extractImageUrls(json['images']);
    final muscleIds = _extractMuscleIds(json['muscles']);
    final categoryData = _extractCategory(json['category']);

    return Exercise(
      id: _readInt(json['id']),
      name: name.isNotEmpty ? name : 'Exercício sem nome',
      description: description.isNotEmpty
          ? description
          : 'Descrição não disponível para este exercício.',
      categoryId: categoryData.id,
      categoryName: categoryData.name,
      imageUrls: imageUrls,
      muscleIds: muscleIds,
    );
  }

  static Map<String, dynamic>? _selectBestTranslation(dynamic value) {
    if (value is! List || value.isEmpty) return null;

    final translations = value.whereType<Map<String, dynamic>>().toList();

    if (translations.isEmpty) return null;

    // Tenta português primeiro.
    for (final item in translations) {
      final language = item['language'];

      if (_languageMatches(language, 7)) {
        final name = item['name']?.toString().trim() ?? '';
        if (name.isNotEmpty) return item;
      }
    }

    // Depois tenta inglês.
    for (final item in translations) {
      final language = item['language'];

      if (_languageMatches(language, 2)) {
        final name = item['name']?.toString().trim() ?? '';
        if (name.isNotEmpty) return item;
      }
    }

    // Depois pega qualquer tradução com nome válido.
    for (final item in translations) {
      final name = item['name']?.toString().trim() ?? '';
      if (name.isNotEmpty) return item;
    }

    return translations.first;
  }

  static bool _languageMatches(dynamic language, int expectedId) {
    if (language is int) {
      return language == expectedId;
    }

    if (language is String) {
      return language == expectedId.toString();
    }

    if (language is Map<String, dynamic>) {
      final id = language['id'];
      if (id is int) return id == expectedId;
      if (id is String) return id == expectedId.toString();

      final shortName = language['short_name']?.toString().toLowerCase();
      final code = language['code']?.toString().toLowerCase();

      if (expectedId == 7) {
        return shortName == 'pt' || code == 'pt';
      }

      if (expectedId == 2) {
        return shortName == 'en' || code == 'en';
      }
    }

    return false;
  }

  static List<String> _extractImageUrls(dynamic value) {
    if (value is! List) return [];

    final urls = <String>[];

    for (final item in value) {
      String imageUrl = '';

      if (item is String) {
        imageUrl = item.trim();
      } else if (item is Map<String, dynamic>) {
        imageUrl = item['image']?.toString().trim() ??
            item['image_url']?.toString().trim() ??
            item['url']?.toString().trim() ??
            '';
      }

      if (imageUrl.isEmpty || imageUrl == 'null') continue;

      final fullUrl = imageUrl.startsWith('http')
          ? imageUrl
          : 'https://wger.de$imageUrl';

      urls.add(fullUrl);
    }

    return urls;
  }

  static List<int> _extractMuscleIds(dynamic value) {
    if (value is! List) return [];

    final ids = <int>[];

    for (final item in value) {
      if (item is int) {
        ids.add(item);
      } else if (item is String) {
        final parsed = int.tryParse(item);
        if (parsed != null) ids.add(parsed);
      } else if (item is Map<String, dynamic>) {
        final id = _readInt(item['id']);
        if (id != 0) ids.add(id);
      }
    }

    return ids;
  }

  static _CategoryData _extractCategory(dynamic value) {
    if (value is int) {
      return _CategoryData(id: value, name: '');
    }

    if (value is String) {
      return _CategoryData(id: int.tryParse(value) ?? 0, name: '');
    }

    if (value is Map<String, dynamic>) {
      return _CategoryData(
        id: _readInt(value['id']),
        name: value['name']?.toString() ?? '',
      );
    }

    return const _CategoryData(id: 0, name: '');
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class _CategoryData {
  final int id;
  final String name;

  const _CategoryData({
    required this.id,
    required this.name,
  });
}