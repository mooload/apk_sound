import 'package:tes_2_tolong/audio_service.dart';
import 'dart:convert';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class MatchingService {
  Future<bool> testVoice(AudioService audioService) async {
    // Simulate the feature extraction of the test voice
    final testFeatures = await audioService.extractFeatures(audioService.recordedFilePath);

    // Load the saved features
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File featureFile = File('${appDirectory.path}/features.json');

    if (!await featureFile.exists()) {
      return false;
    }

    final savedFeatures = jsonDecode(await featureFile.readAsString());

    // Dummy matching logic
    // In practice, you will compare extracted features such as pitch and amplitude
    return (testFeatures["pitch"] == savedFeatures["pitch"]) &&
        (testFeatures["amplitude"] == savedFeatures["amplitude"]);
  }

}
