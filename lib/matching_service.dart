import 'audio_service.dart';

class MatchingService {
  Future<bool> testVoice(AudioService audioService) async {
    // Extract features from the new recording
    final testFeatures = await audioService.extractFeatures(audioService.recordedFilePath);

    // Load the saved features
    final savedFeatures = await audioService.loadFeatures();

    if (savedFeatures.isEmpty) {
      return false; // No features saved previously
    }

    // Implement actual matching logic here
    // For demonstration, we check if the pitch and amplitude are equal
    return (testFeatures["pitch"] == savedFeatures["pitch"]) &&
        (testFeatures["amplitude"] == savedFeatures["amplitude"]);
  }
}
