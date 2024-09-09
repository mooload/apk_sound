import 'package:flutter/material.dart';
import 'audio_service.dart';
import 'matching_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Matching',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioService _audioService = AudioService();
  final MatchingService _matchingService = MatchingService();
  String _statusMessage = "Press the button to record.";

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _recordSample() async {
    await _requestPermissions();
    await _audioService.startRecording();
    setState(() {
      _statusMessage = "Recording sample...";
    });
    await Future.delayed(const Duration(seconds: 5)); // Simulate recording time
    await _audioService.stopRecordingAndSaveFeatures();
    setState(() {
      _statusMessage = "Sample recorded and features saved.";
    });
  }

  Future<void> _testMatching() async {
    await _requestPermissions();
    await _audioService.startRecording();
    setState(() {
      _statusMessage = "Recording test voice...";
    });
    await Future.delayed(const Duration(seconds: 5)); // Simulate recording time
    await _audioService.stopRecordingAndSaveFeatures();

    bool isMatch = await _matchingService.testVoice(_audioService);
    setState(() {
      _statusMessage = isMatch
          ? "Congrats, sound matching!"
          : "Sorry, not recognize you.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tolong Matching App",
        style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recordSample,
              child: const Text("Record Sample"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testMatching,
              child: const Text("Test Voice Matching"),
            ),
          ],
        ),
      ),
    );
  }
}
