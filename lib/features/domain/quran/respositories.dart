import '../entities/surah_entity.dart';
import '../entities/ayah_entity.dart';

abstract class QuranRepository {
  Future<List<SurahEntity>> getSurahs();
  Future<List<AyahEntity>> getSurahDetails(int surahNumber);
}
