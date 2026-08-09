import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../cubit/surah_details_cubit.dart';
import '../cubit/surah_details_state.dart';
import '../../../domain/quran/entities/ayah_entity.dart';

class SurahDetailsScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailsScreen({super.key, required this.surahNumber, required this.surahName});

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<AyahEntity> _ayahs = [];
  double _fontSize = 28.0;
  final AudioPlayer _player = AudioPlayer();
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    // Use SurahDetailsCubit to load ayahs for this surah
    context.read<SurahDetailsCubit>().loadSurah(widget.surahNumber);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(String? url, int index) async {
    if (url == null || url.isEmpty) return;
    if (_playingIndex == index) {
      await _player.pause();
      setState(() => _playingIndex = null);
      return;
    }

    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      setState(() => _playingIndex = index);
      _player.onPlayerComplete.listen((event) {
        setState(() => _playingIndex = null);
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to play audio')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surahName, style: GoogleFonts.amiri())),
      body: BlocConsumer<SurahDetailsCubit, SurahDetailsState>(
        listener: (context, state) {
          if (state is SurahDetailsLoaded) {
            _ayahs = state.ayahs;
          }
        },
        builder: (context, state) {
          if (state is SurahDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SurahDetailsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => context.read<SurahDetailsCubit>().loadSurah(widget.surahNumber), child: const Text('Retry'))
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.format_size),
                    Expanded(
                      child: Slider(
                        min: 14,
                        max: 48,
                        value: _fontSize,
                        onChanged: (v) => setState(() => _fontSize = v),
                      ),
                    ),
                    Text('${_fontSize.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = _ayahs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              ayah.text,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.amiri(fontSize: _fontSize, height: 1.5),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              CircleAvatar(child: Text('${ayah.number}', style: const TextStyle(fontSize: 12))),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: Icon(_playingIndex == index ? Icons.pause_circle : Icons.play_circle, size: 28, color: Theme.of(context).primaryColor),
                                onPressed: () => _togglePlay(ayah.audio, index),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}


