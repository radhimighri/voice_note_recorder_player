class VoiceNoteStrings {
  final String voiceNote;
  final String recordVoiceNote;
  final String recording;
  final String stopRecording;
  final String microphonePermissionRequired;
  final String confirm;
  final String cancel;
  final String save;
  final String delete;
  final String audioReadyToSave;
  final String playbackSpeed;

  const VoiceNoteStrings({
    this.voiceNote = 'Voice Note',
    this.recordVoiceNote = 'Record Voice Note',
    this.recording = 'Recording...',
    this.stopRecording = 'Stop Recording',
    this.microphonePermissionRequired =
        'Microphone permission is required to record audio.',
    this.confirm = 'Confirm',
    this.cancel = 'Cancel',
    this.save = 'Save',
    this.delete = 'Delete',
    this.audioReadyToSave = 'Audio ready to save',
    this.playbackSpeed = 'Speed',
  });
}
