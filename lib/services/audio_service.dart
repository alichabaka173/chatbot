import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final FlutterTts _flutterTts = FlutterTts();
  
  AudioService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS Error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('TTS Stop Error: $e');
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
