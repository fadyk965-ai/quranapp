import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/quran/repositories/quran_repository.dart';
import '../../../domain/quran/entities/ayah_entity.dart';
import 'surah_details_state.dart';

class SurahDetailsCubit extends Cubit<SurahDetailsState> {
  final QuranRepository repository;

  SurahDetailsCubit(this.repository) : super(SurahDetailsInitial());

  Future<void> loadSurah(int surahNumber) async {
    print('[SurahDetailsCubit] loadSurah($surahNumber)');
    emit(SurahDetailsLoading());
    try {
      final ayahs = await repository.getSurahDetails(surahNumber);
      print('[SurahDetailsCubit] got ${ayahs.length} ayahs');
      emit(SurahDetailsLoaded(ayahs));
    } catch (e) {
      print('[SurahDetailsCubit] error: $e');
      emit(SurahDetailsError(e.toString()));
    }
  }
}

