import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String _progressKey = 'user_progress';

  Future<UserProgress> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_progressKey);
      
      if (jsonString != null) {
        return UserProgress.fromJsonString(jsonString);
      }
    } catch (e) {
      print('Error loading progress: $e');
    }
    
    return UserProgress();
  }

  Future<void> saveProgress(UserProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_progressKey, progress.toJsonString());
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  Future<void> clearProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_progressKey);
    } catch (e) {
      print('Error clearing progress: $e');
    }
  }
}
