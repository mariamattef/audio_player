import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SoundPlayerWidget extends StatefulWidget {
  final Playlist playList;
  final void Function()? trigger;
  const SoundPlayerWidget({required this.playList, this.trigger, super.key});

  @override
  State<SoundPlayerWidget> createState() => _SoundPlayerWidgetState();
}

class _SoundPlayerWidgetState extends State<SoundPlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int valueEx = 0;
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;
  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
      volume: volumeEx,
      widget.playList,
      autoStart: false,
      loopMode: LoopMode.playlist,
    );
    assetsAudioPlayer.currentPosition.listen((event) {
      valueEx = event.inSeconds;
    });
    assetsAudioPlayer.volume.listen((event) {
      setState(() {
        volumeEx = event;
      });
    });
    assetsAudioPlayer.playlistFinished.listen((event) {
      if (event && widget.playList.audios.length == 1) {
        widget.trigger?.call();
      }
    });
    assetsAudioPlayer.playSpeed.listen((event) {
      setState(() {
        playSpeedEx = event;
      });
    });

    // setState(() {});
  }

  @override
  // void dispose() {
  //   assetsAudioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 390,
              height: 450,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              assetsAudioPlayer.getCurrentAudioTitle == ''
                                  ? 'No song selected'
                                  : assetsAudioPlayer.getCurrentAudioTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            getBtnWidget,
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed:
                                        snapshots.data?.current?.index == 0
                                            ? null
                                            : () {
                                                assetsAudioPlayer.previous();
                                              },
                                    icon: const Icon(Icons.skip_previous)),
                                IconButton(
                                    onPressed: snapshots.data?.current?.index ==
                                            (assetsAudioPlayer.playlist?.audios
                                                        .length ??
                                                    0) -
                                                1
                                        ? null
                                        : () {
                                            assetsAudioPlayer.next();
                                          },
                                    icon: const Icon(Icons.skip_next)),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'volume',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SegmentedButton(
                                      selected: {volumeEx},
                                      onSelectionChanged: (values) {
                                        changeVolume(values);
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_up),
                                          value: 1.0,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_down),
                                          value: 0.5,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_mute_rounded),
                                          value: 0.0,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'speed',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: [
                                      SegmentedButton(
                                        selected: {playSpeedEx},
                                        onSelectionChanged: (values) {
                                          changePlaySpeed(values);
                                        },
                                        segments: const [
                                          ButtonSegment(
                                            icon: Text('1x'),
                                            value: 1.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('2x'),
                                            value: 4.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('3x'),
                                            value: 8.0,
                                          ),
                                          ButtonSegment(
                                            icon: Text('4x'),
                                            value: 16.0,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: valueEx.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  valueEx = value.toInt();
                                });
                              },
                              onChangeEnd: (value) async {
                                await assetsAudioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              },
                              min: 0,
                              max: snapshots.data?.duration.inSeconds
                                      .toDouble() ??
                                  0.0,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${convertSeconds(valueEx)} /  ${convertSeconds(snapshots.data?.duration.inSeconds ?? 0)} ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ]),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  void changeVolume(Set<double> values) {
    volumeEx = values.first.toDouble();
    assetsAudioPlayer.setVolume(volumeEx);
    setState(() {});
  }

  void changePlaySpeed(Set<double> values) {
    playSpeedEx = values.first.toDouble();
    assetsAudioPlayer.setPlaySpeed(playSpeedEx);
    setState(() {});
  }

  String convertSeconds(int seconds) {
    String min = (seconds / 60).floor().toString().padLeft(2, '0');
    String sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Widget get getBtnWidget {
    return assetsAudioPlayer.builderIsPlaying(builder: (context, isplaying) {
      return FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            if (isplaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          child: Icon(
            isplaying ? Icons.pause : Icons.play_arrow,
            size: 50,
            color: Colors.grey,
          ));
    });
  }
}
