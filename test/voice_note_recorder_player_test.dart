import 'package:flutter_test/flutter_test.dart';

import 'package:voice_note_recorder_player/voice_note_recorder_player.dart';

void main() {
  test('VoiceNoteStrings defaults', () {
    const strings = VoiceNoteStrings();
    expect(strings.voiceNote, 'Voice Note');
    expect(strings.recordVoiceNote, 'Record Voice Note');
  });
}
