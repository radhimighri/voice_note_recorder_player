import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voice_recorder_provider.dart';
import 'voice_note_strings.dart';

class VoiceRecorderBottomSheet extends StatefulWidget {
  final void Function(String filePath) onRecorded;
  final VoiceNoteStrings strings;
  final Color? primaryColor;
  final Color? cardColor;
  final Color? errorColor;

  const VoiceRecorderBottomSheet({
    super.key,
    required this.onRecorded,
    this.strings = const VoiceNoteStrings(),
    this.primaryColor,
    this.cardColor,
    this.errorColor,
  });

  @override
  State<VoiceRecorderBottomSheet> createState() =>
      _VoiceRecorderBottomSheetState();
}

class _VoiceRecorderBottomSheetState extends State<VoiceRecorderBottomSheet>
    with SingleTickerProviderStateMixin {
  late final VoiceRecorderProvider _controller;

  late final AnimationController _animationController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = VoiceRecorderProvider(onRecorded: widget.onRecorded);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _controller.start();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final primary = widget.primaryColor ?? theme.colorScheme.primary;
    final cardBg = widget.cardColor ?? theme.cardColor;
    final error = widget.errorColor ?? theme.colorScheme.error;

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<VoiceRecorderProvider>(
        builder: (context, c, _) {
          if (c.permissionDenied) {
            return Container(
              width: screenWidth,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: error.withValues(alpha: 0.1),
                          border: Border.all(color: error, width: 2),
                        ),
                        child: Icon(
                          Icons.mic_off_rounded,
                          color: error,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.strings.microphonePermissionRequired,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(widget.strings.confirm),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container(
            width: screenWidth,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: error.withValues(alpha: 0.1),
                          border: Border.all(color: error, width: 2),
                        ),
                        child: Icon(Icons.mic, color: error, size: 40),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.strings.recording,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _formatDuration(c.seconds),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 4,
                          height: (c.seconds % 2 == 0)
                              ? (20 + (index * 8.0))
                              : (40 - (index * 4.0)),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: c.isStopping
                            ? null
                            : () async {
                                await c.stop();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                        icon: const Icon(
                          Icons.stop_circle,
                          size: 24,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.strings.stopRecording,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
