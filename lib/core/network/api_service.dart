import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  // 1. طلب قائمة السور باستخدام http مع الحماية HTTPS
  Future<List<dynamic>> getSurahListWithHttp() async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('فشل في تحميل قائمة السور عبر HTTP');
    }
  }

  // 2. طلب تفاصيل سورة باستخدام Dio مع HTTPS
  Future<Map<String, dynamic>> getSurahDetailsWithDio(int surahNumber) async {
    try {
      final response = await dio.get('https://api.alquran.cloud/v1/surah/$surahNumber');
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.message ?? 'حدث خطأ أثناء جلب البيانات عبر Dio');
    }
  }

  // 3. طلب مواقيت الصلاة
  Future<Map<String, dynamic>> getPrayerTimes({
    required String city,
    required String country,
  }) async {
    try {
      final response = await dio.get(
        'https://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': city,
          'country': country,
          'method': 5,
        },
      );
      return response.data['data']['timings'];
    } on DioException catch (e) {
      throw Exception(e.message ?? 'فشل في جلب مواقيت الصلاة');
    }
  }

  // 4. طلب رابط الصوت
  Future<String> getSurahAudioUrl({
    required int reciterId,
    required int surahNumber,
  }) async {
    try {
      final response = await dio.get(
        'https://api.quran.com/api/v4/chapter_recitations/$reciterId/$surahNumber',
      );
      return response.data['audio_file']['audio_url'];
    } on DioException catch (e) {
      throw Exception(e.message ?? 'فشل في جلب رابط تلاوة السورة');
    }
  }
}
