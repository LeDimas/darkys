import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:darky_app/presentation/widgets/video_container.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/storage_service.dart';

class CertainVideoTut extends StatefulWidget {
  CertainVideoTut({
    Key key,
    this.link,
    this.isYoutube,
    this.name,
  }) : super(key: key);
  final String link;
  final bool isYoutube;
  final String name;

  @override
  _CertainVideoTutState createState() => _CertainVideoTutState();
}

class _CertainVideoTutState extends State<CertainVideoTut> {
  YoutubePlayerController _controller;
  TextEditingController _idController = TextEditingController();
  TextEditingController _seekToController;
  PlayerState _playerState;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    if (widget.isYoutube) {
      var id = YoutubePlayer.convertUrlToId(widget.link);
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(listener);
    }
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (widget.isYoutube) {
      _controller.pause();
    }

    super.deactivate();
  }

  @override
  void dispose() {
    if (widget.isYoutube) {
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Add video"),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color(0xFF263248),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: widget.isYoutube
                            ? YoutubePlayerBuilder(
                                onExitFullScreen: () {
                                  // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                  SystemChrome.setPreferredOrientations(
                                      DeviceOrientation.values);
                                },
                                player: YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.blueAccent,
                                  onReady: () {
                                    _isPlayerReady = true;
                                  },
                                ),
                                builder: (context, player) => ListView(
                                  children: [
                                    player,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // _space,
                                          // _text('Title', _videoMetaData.title),
                                          // _space,
                                          // _text('Channel', _videoMetaData.author),
                                          // _space,
                                          // _text('Video Id', _videoMetaData.videoId),
                                          // _space,
                                          Row(
                                            children: [
                                              _text(
                                                'Playback Quality',
                                                _controller
                                                    .value.playbackQuality,
                                              ),
                                              const Spacer(),
                                              _text(
                                                'Playback Rate',
                                                '${_controller.value.playbackRate}x  ',
                                              ),
                                            ],
                                          ),
                                          _space,

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  _controller.value.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                ),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                        _controller
                                                                .value.isPlaying
                                                            ? _controller
                                                                .pause()
                                                            : _controller
                                                                .play();
                                                        setState(() {});
                                                      }
                                                    : null,
                                              ),
                                              IconButton(
                                                icon: Icon(_muted
                                                    ? Icons.volume_off
                                                    : Icons.volume_up),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                        _muted
                                                            ? _controller
                                                                .unMute()
                                                            : _controller
                                                                .mute();
                                                        setState(() {
                                                          _muted = !_muted;
                                                        });
                                                      }
                                                    : null,
                                              ),
                                              FullScreenButton(
                                                controller: _controller,
                                                color: Colors.blueAccent,
                                              ),
                                            ],
                                          ),
                                          _space,
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                "Volume",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Expanded(
                                                child: Slider(
                                                  inactiveColor:
                                                      Colors.transparent,
                                                  value: _volume,
                                                  min: 0.0,
                                                  max: 100.0,
                                                  divisions: 10,
                                                  label: '${(_volume).round()}',
                                                  onChanged: _isPlayerReady
                                                      ? (value) {
                                                          setState(() {
                                                            _volume = value;
                                                          });
                                                          _controller.setVolume(
                                                              _volume.round());
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          _space,
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 800),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color:
                                                  _getStateColor(_playerState),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _playerState.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RemoteVideoContainer(
                                testFunction: () {
                                  print(widget.name);
                                },
                                link: widget.link,
                                deleteFunction: () {
                                  FireStorageService
                                      .deleteVideoFromFirebaseStorage(
                                          widget.link);
                                  DatabaseService.deleteVideoFromFirestore(
                                      widget.name);
                                })))),
          ]),
        ));
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);
}
