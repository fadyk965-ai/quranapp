import '../../../domain/quran/entities/ayah_entity.dart';

class AyahModel extends AyahEntity {
  final int numberInSurah;

  AyahModel({
    required this.numberInSurah,
    required String text,
    String? audio,
  }) : super(number: numberInSurah, text: text, audio: audio);

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      numberInSurah: json['numberInSurah'] as int? ?? json['number'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      audio: json['audio'] as String?,
    );
  }
}


