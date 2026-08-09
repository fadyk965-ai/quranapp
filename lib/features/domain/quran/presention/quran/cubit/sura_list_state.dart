import '../../../domain/quran/entities/surah_entity.dart';

abstract class SurahListState {}

class SurahListInitial extends SurahListState {}
class SurahListLoading extends SurahListState {}
class SurahListLoaded extends SurahListState {
  final List<SurahEntity> surahs;
  SurahListLoaded(this.surahs);
}
class SurahListError extends SurahListState {
  final String message;
  SurahListError(this.message);
}

