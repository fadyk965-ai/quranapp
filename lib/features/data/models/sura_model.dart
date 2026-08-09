import '../../../domain/quran/entities/surah_entity.dart';

class SurahModel extends SurahEntity {
  const SurahModel({
    required super.number,
    required super.name,
    required super.englishName,
    required super.numberOfAyahs,
    required super.revelationType,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }
}
