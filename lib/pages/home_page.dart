import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player_song/pages/drop_down_list.dart';
import 'package:audio_player_song/pages/play_list_page.dart';
import 'package:audio_player_song/widgets/sound-player.widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playListEx = Playlist(audios: [
    Audio('assets/1.mp3',
        metas: Metas(
            title: 'Track 1',
            artist: 'Artist 1',
            album: 'Album 1',
            image: const MetasImage.asset('assets/1.jpg'))),
    Audio('assets/2.mp3',
        metas: Metas(
            title: 'Track 2',
            artist: 'Artist 2',
            album: 'Album 2',
            image: const MetasImage.asset('assets/2.jpg'))),
    Audio(
      'assets/3.mp3',
      metas: Metas(
          title: 'Track 3',
          artist: 'Artist 3',
          album: 'Album 3',
          image: const MetasImage.asset('assets/3.jpg')),
    ),
    Audio(
      'assets/4.wav',
      metas: Metas(
          title: 'Track 4',
          artist: 'Artist 4',
          album: 'Album 4',
          image: const MetasImage.asset('assets/4.wav')),
    ),
    Audio(
      'assets/5.wav',
      metas: Metas(
          title: 'Track 5',
          artist: 'Artist 5',
          album: 'Album 5',
          image: const MetasImage.asset('assets/5.wav')),
    ),
    Audio(
      'assets/6.wav',
      metas: Metas(
          title: 'Track 6',
          artist: 'Artist 6',
          album: 'Album 6',
          image: const MetasImage.asset('assets/6.wav')),
    ),
    Audio(
      'assets/7.wav',
      metas: Metas(
          title: 'Track 7',
          artist: 'Artist 7',
          album: 'Album 7',
          image: const MetasImage.asset('assets/7.wav')),
    )
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('homePage'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => PlayListPage(
                                playlist: playListEx,
                              )));
                },
                icon: Icon(Icons.playlist_add_check_circle))
          ],
        ),
        body: SoundPlayerWidget(playList: playListEx));
  }
}
