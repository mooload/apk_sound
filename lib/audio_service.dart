import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late String recordedFilePath;

  Future<void> startRecording() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    recordedFilePath = '${appDirectory.path}/audio_sample.wav';
    await _recorder.openRecorder();
    await _recorder.startRecorder(toFile: recordedFilePath);
  }

  Future<void> stopRecordingAndSaveFeatures() async {
    await _recorder.stopRecorder();
    // Placeholder for feature extraction logic (e.g., pitch and amplitude)
    final Map<String, dynamic> features = await extractFeatures(recordedFilePath);
    await _saveFeatures(features);
  }

  Future<Map<String, dynamic>> extractFeatures(String filePath) async {
    // Dummy feature extraction logic
    // You can implement pitch and amplitude extraction here
    return {
      "pitch": 440.0,  // Replace with actual pitch value
      "amplitude": 0.5 // Replace with actual amplitude value
    };
  }

  Future<void> _saveFeatures(Map<String, dynamic> features) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File featureFile = File('${appDirectory.path}/features.json');
    await featureFile.writeAsString(features.toString());
  }
}
