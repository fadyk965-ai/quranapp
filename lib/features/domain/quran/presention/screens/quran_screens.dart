import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/surah_list_cubit.dart';
import '../cubit/surah_list_state.dart';
import 'surah_details_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allSurahs = [];
  List<dynamic> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    context.read<SurahListCubit>().fetchSurahs();
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs
            .where((surah) =>
        surah.name.contains(query) ||
            surah.englishName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: BlocConsumer<SurahListCubit, SurahListState>(
        listener: (context, state) {
          if (state is SurahListLoaded) {
            _allSurahs = state.surahs;
            _filteredSurahs = state.surahs;
          }
        },
        builder: (context, state) {
          if (state is SurahListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SurahListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.read<SurahListCubit>().fetchSurahs(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is SurahListLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSurahs,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن سورة...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth >= 1100) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth >= 650) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _filteredSurahs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: constraints.maxWidth >= 650 ? 2.6 : 3.2,
                        ),
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          final cardColor = isDark ? Colors.green[900] : Colors.white;
                          final accent = surah.revelationType == 'Meccan'
                              ? Colors.amber[700]
                              : Colors.teal;

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SurahDetailsScreen(surahNumber: surah.number, surahName: surah.name),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (accent ?? primary).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: accent,
                                    child: Text(
                                      '${surah.number}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          surah.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${surah.englishName} • ${surah.numberOfAyahs} آية',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
