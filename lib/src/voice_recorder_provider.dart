import 'dart:async';
import 'package:flutter/foundation.dart';
import 'audio_recorder_service.dart';

class VoiceRecorderProvider extends ChangeNotifier {
  final void Function(String filePath) onRecorded;

  final AudioRecorderService _recorder = AudioRecorderService();
  Timer? _timer;

  int seconds = 0;
  bool permissionDenied = false;
  bool isStopping = false;
  String? currentTempPath;

  VoiceRecorderProvider({required this.onRecorded});

  Future<void> start() async {
    currentTempPath = await _recorder.startRecording();
    if (currentTempPath == null) {
      permissionDenied = true;
      notifyListeners();
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds++;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> stop() async {
    if (permissionDenied || isStopping) return;
    isStopping = true;
    notifyListeners();

    try {
      await _recorder.stopRecording();
      _timer?.cancel();
      final path = currentTempPath;
      if (path != null) onRecorded(path);
    } finally {
      isStopping = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }
}
