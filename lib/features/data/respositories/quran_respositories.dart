import '../../../domain/quran/entities/surah_entity.dart';
import '../../../domain/quran/repositories/quran_repository.dart';
import '../datasources/quran_remote_data_source.dart';
import '../models/ayah_model.dart';
import '../../../domain/quran/entities/ayah_entity.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSourceImpl remoteDataSource;

  QuranRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SurahEntity>> getSurahs() async {
    return await remoteDataSource.getSurahs();
  }

  @override
  Future<List<AyahEntity>> getSurahDetails(int surahNumber) async {
    final ayahModels = await remoteDataSource.getSurahDetails(surahNumber);
    return ayahModels.map<AyahEntity>((m) => m as AyahEntity).toList();
  }
}
