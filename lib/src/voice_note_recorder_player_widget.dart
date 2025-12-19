import 'package:flutter/material.dart';

import 'audio_player_widget.dart';
import 'voice_note_strings.dart';

class VoiceNoteRecorderPlayer extends StatelessWidget {
  final String? tempVoiceNotePath;
  final String? savedVoiceNotePath;
  final bool isLoading;
  final bool isLocked;
  final bool enabled;

  final VoidCallback onOpenRecorder;
  final VoidCallback onSaveTemp;
  final VoidCallback onCancelTemp;
  final VoidCallback onDeleteSaved;

  final VoiceNoteStrings strings;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? onSecondaryColor;
  final Color? successColor;
  final Color? errorColor;

  const VoiceNoteRecorderPlayer({
    super.key,
    required this.tempVoiceNotePath,
    required this.savedVoiceNotePath,
    required this.isLoading,
    required this.isLocked,
    required this.onOpenRecorder,
    required this.onSaveTemp,
    required this.onCancelTemp,
    required this.onDeleteSaved,
    this.enabled = true,
    this.strings = const VoiceNoteStrings(),
    this.primaryColor,
    this.secondaryColor,
    this.onSecondaryColor,
    this.successColor,
    this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.colorScheme.primary;
    final secondary = secondaryColor ?? theme.colorScheme.secondary;
    final onSecondary = onSecondaryColor ?? theme.colorScheme.onSecondary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic_rounded, color: primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  strings.voiceNote,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (enabled && savedVoiceNotePath == null && !isLocked)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onOpenRecorder,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              secondary,
                              secondary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: secondary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic, color: onSecondary, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              strings.recordVoiceNote,
                              style: TextStyle(
                                color: onSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (tempVoiceNotePath != null && savedVoiceNotePath == null)
              _SaveCancelVoiceNoteContainer(
                isLoading: isLoading,
                onSave: onSaveTemp,
                onCancel: onCancelTemp,
                strings: strings,
                primaryColor: primary,
                successColor: successColor,
                errorColor: errorColor,
              ),

            if (savedVoiceNotePath != null) ...[
              AudioPlayerWidget(
                path: savedVoiceNotePath!,
                strings: strings,
                primaryColor: primary,
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: enabled ? onDeleteSaved : null,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: errorColor ?? theme.colorScheme.error,
                  ),
                  label: Text(
                    strings.delete,
                    style: TextStyle(
                      color: errorColor ?? theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: errorColor ?? theme.colorScheme.error,
                    side: BorderSide(
                      color: (errorColor ?? theme.colorScheme.error)
                          .withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: (errorColor ?? theme.colorScheme.error)
                        .withValues(alpha: 0.05),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SaveCancelVoiceNoteContainer extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoiceNoteStrings strings;
  final Color primaryColor;
  final Color? successColor;
  final Color? errorColor;

  const _SaveCancelVoiceNoteContainer({
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
    required this.strings,
    required this.primaryColor,
    this.successColor,
    this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final success = successColor ?? const Color(0xFF4CAF50); // Default success
    final error = errorColor ?? theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.08),
            primaryColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: primaryColor, size: 48),
          const SizedBox(height: 12),
          Text(
            strings.audioReadyToSave,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.check, size: 20),
                    label: Text(strings.save),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close, size: 20),
                    label: Text(strings.cancel),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: error,
                      side: BorderSide(color: error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
