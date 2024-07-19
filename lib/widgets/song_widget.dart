import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player_song/widgets/sound-player.widget.dart';
import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;
  const SongWidget({required this.audio, super.key});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    assetsAudioPlayer.open(
      widget.audio,
      autoStart: false,
    );
    super.initState();
  }

  // void dispose() {
  //   assetsAudioPlayer.dispose();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    return ListTile(
      trailing: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (ctx, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshots.data == null) {
              return SizedBox.shrink();
            }

            return Text(
                style: TextStyle(fontSize: 15),
                convertSeconds(snapshots.data?.duration.inSeconds ?? 0));
          }),
      leading: CircleAvatar(
        child: Center(
          child: Text(
              '${widget.audio.metas.artist?.split(' ').first[0]}${widget.audio.metas.artist?.split(' ').last[0].toUpperCase()}'),
        ),
      ),
      title: Text(widget.audio.metas.title ?? 'No Title'),
      subtitle: Text(widget.audio.metas.artist ?? 'No atrist'),
      onTap: () async {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Play / Pause'),
                content: Container(
                  constraints: BoxConstraints(maxHeight: 500, maxWidth: 300),
                  child: SoundPlayerWidget(
                      trigger: () {
                        Navigator.pop(ctx);
                      },
                      playList: Playlist(audios: [
                        widget.audio,
                      ])),
                ),
              );
            });
      },
    );
  }

  String convertSeconds(int seconds) {
    String min = (seconds / 60).floor().toString().padLeft(2, '0');
    String sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
