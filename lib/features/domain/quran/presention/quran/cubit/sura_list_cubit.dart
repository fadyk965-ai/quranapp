import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/quran/repositories/quran_repository.dart';
import 'surah_list_state.dart';

class SurahListCubit extends Cubit<SurahListState> {
  final QuranRepository repository;

  SurahListCubit(this.repository) : super(SurahListInitial());

  Future<void> fetchSurahs() async {
    print('[SurahListCubit] fetchSurahs called');
    emit(SurahListLoading());
    try {
      final surahs = await repository.getSurahs();
      print('[SurahListCubit] fetched ${surahs.length} surahs');
      emit(SurahListLoaded(surahs));
    } catch (e) {
      print('[SurahListCubit] error: $e');
      emit(SurahListError(e.toString()));
    }
  }
}

