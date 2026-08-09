import '../../../domain/quran/entities/surah_entity.dart';
import '../../../domain/quran/entities/ayah_entity.dart';

abstract class QuranState {}

class QuranInitialState extends QuranState {}
class QuranLoadingState extends QuranState {}
class QuranSuccessState extends QuranState {
  final List<SurahEntity> surahs;
  QuranSuccessState(this.surahs);
}
class QuranErrorState extends QuranState {
  final String message;
  QuranErrorState(this.message);
}

class QuranSurahLoadingState extends QuranState {}
class QuranSurahSuccessState extends QuranState {
  final List<AyahEntity> ayahs;
  QuranSurahSuccessState(this.ayahs);
}
class QuranSurahErrorState extends QuranState {
  final String message;
  QuranSurahErrorState(this.message);
}
