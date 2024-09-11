import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:fftea/fftea.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';

class AudioService {
  final FlutterSoundRecord _recorder = FlutterSoundRecord();
  String recordedFilePath = "";

  Future<void> startRecording() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    recordedFilePath = '${appDirectory.path}/audio_sample.wav';
    await _recorder.isRecording();
    await _recorder.start(path: recordedFilePath );
  }

  Future<void> stopRecordingAndSaveFeatures() async {
    await _recorder.stop();
    // Extract features and save them
    final features = await extractFeatures(recordedFilePath);
    await saveFeatures(features);
  }

  /// Extracts features such as pitch and amplitude using FFT.
  Future<Map<String, dynamic>> extractFeatures(String filePath) async {
    // Read the recorded file
    File audioFile = File(filePath);
    Uint8List wavData = await audioFile.readAsBytes();

    // Skip the WAV header (44 bytes) to get to the raw PCM data
    Uint8List pcmData = wavData.sublist(44); // raw audio data starts after the 44-byte header

    // Convert Uint8List to Float32List for FFT (Assuming 16-bit PCM WAV format)
    List<double> audioSample = pcmData.buffer.asInt16List().map((e) => e.toDouble()).toList();
    // List<double> audioSample = AMR_WB.map((e) => e.x).toList();
    // Perform FFT using fftea package
    final fft = FFT(audioSample.length);
    final freq = fft.realFft(audioSample);

    List<double> converted = freq.map((e) => e.x).toList();
    // Example: extract amplitude and pitch from the FFT results
    double amplitude = calculateAmplitude(converted);
    double pitch = calculatePitch(converted);

    return {
      'pitch': pitch,
      'amplitude': amplitude,
    };
  }

  Future<void> saveFeatures(Map<String, dynamic> features) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory.path);
    File featureFile = File('${appDirectory.path}/features.json');
    await featureFile.writeAsString(jsonEncode(features));
  }
  // Function to calculate amplitude (simplified)
  double calculateAmplitude(List<double> fftResult) {
    double amplitude = fftResult.fold(0, (sum, value) => sum + value.abs());
    return amplitude / fftResult.length;  // Average amplitude
  }
  // Function to calculate pitch (simplified)
  double calculatePitch(List<double> fftResult) {
    int peakIndex = fftResult.indexWhere((e) => e == fftResult.reduce((a, b) => a > b ? a : b));
    double frequency = peakIndex * (44100 / fftResult.length);  // Assuming 44100 Hz sampling rate
    return frequency;
  }

  Future<Map<String, dynamic>> loadFeatures() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File featureFile = File('${appDirectory.path}/features.json');
    if (await featureFile.exists()) {
      String content = await featureFile.readAsString();
      return jsonDecode(content);
    }
    return {};
  }

}
