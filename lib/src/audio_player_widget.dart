import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audio_player_controller.dart';
import 'voice_note_strings.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String path;
  final VoiceNoteStrings strings;
  final Color? primaryColor;
  final Color? onPrimaryColor;

  const AudioPlayerWidget({
    super.key,
    required this.path,
    this.strings = const VoiceNoteStrings(),
    this.primaryColor,
    this.onPrimaryColor,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final List<double> speedOptions = const [0.5, 1.0, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = path.split('/').last;
    final primary = primaryColor ?? theme.colorScheme.primary;
    final onPrimary = onPrimaryColor ?? theme.colorScheme.onPrimary;

    return ChangeNotifierProvider(
      create: (_) => AudioPlayerController(path: path),
      child: Consumer<AudioPlayerController>(
        builder: (context, c, _) {
          final maxMs = c.duration.inMilliseconds.toDouble();
          final posMs = c.position.inMilliseconds.toDouble().clamp(0.0, maxMs);

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: 0.05),
                  primary.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.audiotrack_rounded,
                        color: primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.voiceNote,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            fileName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                        activeTrackColor: primary,
                        inactiveTrackColor: primary.withValues(alpha: 0.1),
                        thumbColor: primary,
                        overlayColor: primary.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: posMs,
                        min: 0.0,
                        max: maxMs == 0 ? 1.0 : maxMs,
                        onChanged: (value) => c.updateDrag(value),
                        onChangeStart: (value) => c.startDrag(value),
                        onChangeEnd: (value) => c.endDrag(value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(c.position),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          _formatDuration(c.duration),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              strings.playbackSpeed,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...speedOptions.map((speed) {
                            final isSelected = c.playbackSpeed == speed;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: InkWell(
                                onTap: () => c.changeSpeed(speed),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${speed}x',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Material(
                    color: primary,
                    borderRadius: BorderRadius.circular(28),
                    child: InkWell(
                      onTap: c.togglePlay,
                      borderRadius: BorderRadius.circular(28),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          c.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: onPrimary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
