import 'package:flutter/material.dart';
import 'package:voice_note_recorder_player/voice_note_recorder_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Note Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Voice Note Recorder Player Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _tempPath;
  String? _savedPath;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Test the Voice Note Recorder:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              VoiceNoteRecorderPlayer(
                tempVoiceNotePath: _tempPath,
                savedVoiceNotePath: _savedPath,
                isLoading: _isLoading,
                isLocked: false,
                onOpenRecorder: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => VoiceRecorderBottomSheet(
                      onRecorded: (path) {
                        setState(() {
                          _tempPath = path;
                        });
                      },
                    ),
                  );
                },
                onSaveTemp: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  // Simulate API call
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _savedPath = _tempPath;
                    _tempPath = null;
                    _isLoading = false;
                  });
                },
                onCancelTemp: () {
                  setState(() {
                    _tempPath = null;
                  });
                },
                onDeleteSaved: () {
                  setState(() {
                    _savedPath = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
