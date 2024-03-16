import 'dart:async';
import 'package:Muslim/Core/constant/text_style.dart';
import 'package:Muslim/Models/reader_load_data.dart';
import 'package:Muslim/Models/surah_sound_load_data.dart';
import 'package:Muslim/View/Quran/widget/widget_Api/seek_bar.dart';
import 'package:Muslim/View/Radio/radio_play.dart';
import 'package:Muslim/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

import 'package:rxdart/rxdart.dart' as rxdart;

class AudioScreen extends StatefulWidget {
  const AudioScreen(
      {Key? key, required this.reader, required this.index, required this.list})
      : super(key: key);
  final Reader reader;
  final int index;
  final List<Surah>? list;

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final _player = AudioPlayer();
  Duration defaultDuration = const Duration(milliseconds: 1);
  String? ind;
  int currentIndex = 0;
  int dataIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.index - 1;
      dataIndex = widget.index - 1;
    });

    if (widget.index < 10) {
      ind = "00${widget.index}";
    } else if (widget.index < 100) {
      ind = "0${widget.index}";
    } else if (widget.index > 100) {
      ind = (widget.index.toString());
    }

    _initAudioPlayer(ind!, widget.reader);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.list![currentIndex].englishName!,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: TextFontStyle.notoNastaliqUrduFont,
                    ),
                  ),
                  Text(
                    widget.list![currentIndex].name!,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0XFFD4A331)
                          : Colors.teal,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0XFFD4A331)
                : Colors.teal,
          ),
          SizedBox(
            height: 10.h,
          ),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? defaultDuration,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                onChanged: _player.seek,
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      if (currentIndex > 0) {
                        setState(() {
                          dataIndex = currentIndex;
                          currentIndex--;
                        });
                        if (dataIndex < 10) {
                          ind = "00$dataIndex";
                        } else if (dataIndex < 100) {
                          ind = "0$dataIndex";
                        } else if (dataIndex > 100) {
                          ind = (dataIndex.toString());
                        }

                        _initAudioPlayer(ind!, widget.reader);
                      }
                    },
                    icon: const Icon(Icons.skip_next_outlined)),
                StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const LoadingWidget());
                      } else if (playing != true) {
                        return InkWell(
                          onTap: _player.play,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(44, 212, 163, 49)
                                  : const Color.fromARGB(44, 0, 150, 135),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                            ),
                          ),
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return InkWell(
                          onTap: _player.pause,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(44, 212, 163, 49)
                                  : const Color.fromARGB(44, 0, 150, 135),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.pause,
                            ),
                          ),
                        );
                      }
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const LoadingWidget());
                    }),
                IconButton(
                  onPressed: () {
                    if (currentIndex >= 0 && currentIndex < 113) {
                      setState(() {
                        currentIndex++;
                        dataIndex = currentIndex + 1;
                      });
                      if (dataIndex < 10) {
                        ind = "00$dataIndex";
                      } else if (dataIndex < 100) {
                        ind = "0$dataIndex";
                      } else if (dataIndex > 100) {
                        ind = (dataIndex.toString());
                      }

                      _initAudioPlayer(ind!, widget.reader);
                    }
                  },
                  icon: const Icon(Icons.skip_previous_outlined),
                ),
                IconButton(
                    onPressed: () {
                      Get.bottomSheet(const BottomSheetTimer());
                    },
                    icon: Icon(
                      Icons.timer_outlined,
                      size: 25.r,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          if (currentIndex >= 113)
            Container()
          else
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0XFFD4A331)
                      : Colors.teal,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'التالي',
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: (currentIndex <= 112) ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.list![currentIndex + 1].englishName!,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: TextFontStyle.quranFont),
                              ),
                              Text(
                                widget.list![currentIndex + 1].name!,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily:
                                      TextFontStyle.notoNastaliqUrduFont,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0XFFD4A331)
                                      : Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _initAudioPlayer(
    String ind,
    Reader reader,
  ) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    try {
      var url =
          "https://download.quranicaudio.com/quran/${reader.relativePath}$ind.mp3";
      print('url $url');
      defaultDuration =
          (await _player.setAudioSource(AudioSource.uri(Uri.parse(url))))!;
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }
}
