import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerController extends ChangeNotifier {
  final String path;
  final AudioPlayer _player = AudioPlayer();

  bool isPlaying = false;
  bool isDragging = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackSpeed = 1.0;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<void>? _completeSub;

  AudioPlayerController({required this.path}) {
    _setupPlayer();
  }

  AudioPlayer get player => _player;

  void _setupPlayer() {
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _durationSub = _player.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    _positionSub = _player.onPositionChanged.listen((p) {
      if (isDragging) return;
      position = p;
      notifyListeners();
    });

    _completeSub = _player.onPlayerComplete.listen((_) {
      isPlaying = false;
      position = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> togglePlay() async {
    if (!isPlaying) {
      final Source src = path.startsWith('http')
          ? UrlSource(path)
          : DeviceFileSource(path);
      await _player.play(src);
    } else {
      await _player.pause();
    }
  }

  Future<void> changeSpeed(double speed) async {
    await _player.setPlaybackRate(speed);
    playbackSpeed = speed;
    notifyListeners();
  }

  void startDrag(double valueMs) {
    isDragging = true;
    position = Duration(milliseconds: valueMs.toInt());
    notifyListeners();
  }

  void updateDrag(double valueMs) {
    position = Duration(milliseconds: valueMs.toInt());
    notifyListeners();
  }

  Future<void> endDrag(double valueMs) async {
    await _player.seek(Duration(milliseconds: valueMs.toInt()));
    isDragging = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}
