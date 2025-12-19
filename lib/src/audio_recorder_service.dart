import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isPermissionChecked = false;

  Future<bool> _checkPermission() async {
    if (!_isPermissionChecked) {
      _isPermissionChecked = await _recorder.hasPermission();
    }
    return _isPermissionChecked;
  }

  Future<String?> startRecording() async {
    if (!await _checkPermission()) return null;

    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );

    return filePath;
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  void dispose() {
    _recorder.dispose();
  }
}
