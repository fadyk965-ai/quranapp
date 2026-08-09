import 'package:dio/dio.dart';
import '../../../../core/network/api_service.dart';
import '../../../domain/quran/entities/surah_entity.dart';
import '../models/ayah_model.dart';

class QuranRemoteDataSourceImpl {
  final ApiService apiService;

  QuranRemoteDataSourceImpl(this.apiService);

  Future<List<SurahEntity>> getSurahs() async {
	print('[QuranRemoteDataSource] getSurahs() calling API');
	final list = await apiService.getSurahListWithHttp();
	print('[QuranRemoteDataSource] getSurahs() got ${list.length} items from API');
	return list.map<SurahEntity>((item) {
	  return SurahEntity(
		number: item['number'] as int? ?? 0,
		name: item['name'] as String? ?? '',
		englishName: item['englishName'] as String? ?? '',
		numberOfAyahs: item['numberOfAyahs'] as int? ?? (item['ayahs'] as List?)?.length ?? 0,
		revelationType: item['revelationType'] as String? ?? '',
	  );
	}).toList();
  }

  Future<List<AyahModel>> getSurahDetails(int surahNumber) async {
	try {
	  print('[QuranRemoteDataSource] getSurahDetails($surahNumber) calling API');
	  final data = await apiService.getSurahDetailsWithDio(surahNumber);
	  final ayahs = (data['ayahs'] as List<dynamic>?) ?? [];
	  print('[QuranRemoteDataSource] getSurahDetails: got ${ayahs.length} ayahs');
	  return ayahs.map<AyahModel>((a) => AyahModel.fromJson(a as Map<String, dynamic>)).toList();
	} on DioException catch (e) {
	  print('[QuranRemoteDataSource] getSurahDetails error: ${e.message}');
	  throw Exception(e.message ?? 'Failed to load surah details');
	}
  }

}
