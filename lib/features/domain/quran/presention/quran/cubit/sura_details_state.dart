import '../../../domain/quran/entities/ayah_entity.dart';

abstract class SurahDetailsState {}

class SurahDetailsInitial extends SurahDetailsState {}
class SurahDetailsLoading extends SurahDetailsState {}
class SurahDetailsLoaded extends SurahDetailsState {
  final List<AyahEntity> ayahs;
  SurahDetailsLoaded(this.ayahs);
}
class SurahDetailsError extends SurahDetailsState {
  final String message;
  SurahDetailsError(this.message);
}

