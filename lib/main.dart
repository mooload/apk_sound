import 'package:flutter/material.dart';
import 'audio_service.dart';
import 'matching_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _AudioMatchingHomePageState createState() => _AudioMatchingHomePageState();
}

class _AudioMatchingHomePageState extends State<HomePage> {
  final AudioService _audioService = AudioService();
  final MatchingService _matchingService = MatchingService();

  String _statusMessage = "Press the button to start recording.";

  Future<void> _startRecording() async {
    await _audioService.startRecording();
    setState(() {
      _statusMessage = "Recording...";
    });
  }

  Future<void> _stopRecordingAndSaveFeature() async {
    await _audioService.stopRecordingAndSaveFeatures();
    setState(() {
      _statusMessage = "Feature saved. Now you can test it.";
    });
  }

  Future<void> _testMatching() async {
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
        title: Text('Audio Matching App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_statusMessage),
            ElevatedButton(
              onPressed: _startRecording,
              child: Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: _stopRecordingAndSaveFeature,
              child: Text('Stop and Save Feature'),
            ),
            ElevatedButton(
              onPressed: _testMatching,
              child: Text('Test Voice'),
            ),
          ],
        ),
      ),
    );
  }
}
