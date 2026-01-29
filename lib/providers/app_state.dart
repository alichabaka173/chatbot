import 'package:flutter/foundation.dart';
import '../models/user_progress.dart';
import '../models/lesson_content.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';
import '../services/audio_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AIService _aiService = AIService();
  final AudioService _audioService = AudioService();

  UserProgress _progress = UserProgress();
  bool _isLoading = true;

  UserProgress get progress => _progress;
  bool get isLoading => _isLoading;
  AIService get aiService => _aiService;
  AudioService get audioService => _audioService;

  AppState() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _isLoading = true;
    notifyListeners();

    _progress = await _storageService.loadProgress();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProgress() async {
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }

  void completeLesson(String lessonId, String moduleId, int score) {
    _progress.completeLesson(lessonId, moduleId, score);
    saveProgress();
  }

  void addPoints(int points) {
    _progress.addPoints(points);
    saveProgress();
  }

  bool isLessonUnlocked(int lessonLevel) {
    return lessonLevel <= _progress.level;
  }

  List<Module> getAvailableModules() {
    return LessonContent.getAllModules();
  }

  Future<void> resetProgress() async {
    _progress = UserProgress();
    await saveProgress();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
