import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'features/presentation/quran/cubit/surah_list_cubit.dart';
import 'features/presentation/quran/cubit/surah_details_cubit.dart';
import 'features/presentation/quran/screens/quran_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage and DI
  await Hive.initFlutter();

  // Build Hydrated storage using a platform-appropriate directory.
  late final HydratedStorage storage;
  if (kIsWeb) {
    storage = await HydratedStorage.build(storageDirectory: HydratedStorage.webStorageDirectory);
  } else {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    storage = await HydratedStorage.build(storageDirectory: dir);
  }
  HydratedBloc.storage = storage;

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<SurahListCubit>()),
        BlocProvider(create: (context) => di.sl<SurahDetailsCubit>()),
      ],
      child: MaterialApp(
        title: 'Muslim App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0F5257),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: const QuranScreen(),
      ),
    );
  }
}

