import 'dart:convert';

class UserProgress {
  int level;
  int totalPoints;
  List<String> completedLessons;
  int currentStreak;
  int bestStreak;
  String? lastActivity;
  Map<String, ModuleProgress> moduleProgress;
  List<String> achievements;

  UserProgress({
    this.level = 1,
    this.totalPoints = 0,
    List<String>? completedLessons,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActivity,
    Map<String, ModuleProgress>? moduleProgress,
    List<String>? achievements,
  })  : completedLessons = completedLessons ?? [],
        moduleProgress = moduleProgress ?? {},
        achievements = achievements ?? [];

  void addPoints(int points) {
    totalPoints += points;
    checkLevelUp();
  }

  bool checkLevelUp() {
    int pointsForNextLevel = level * 100;
    if (totalPoints >= pointsForNextLevel) {
      level++;
      return true;
    }
    return false;
  }

  void completeLesson(String lessonId, String moduleId, int score) {
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
    }

    if (!moduleProgress.containsKey(moduleId)) {
      moduleProgress[moduleId] = ModuleProgress();
    }

    moduleProgress[moduleId]!.completed++;
    moduleProgress[moduleId]!.totalScore += score;
    if (score > moduleProgress[moduleId]!.bestScore) {
      moduleProgress[moduleId]!.bestScore = score;
    }

    updateStreak();
    addPoints(score);
    checkAchievements();
  }

  void updateStreak() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    if (lastActivity != today) {
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
      lastActivity = today;
    }
  }

  String? checkAchievements() {
    List<Map<String, dynamic>> achievementsList = [
      {
        'id': 'first_lesson',
        'name': 'Premier pas',
        'condition': completedLessons.length >= 1
      },
      {
        'id': 'five_lessons',
        'name': 'Apprenant motivé',
        'condition': completedLessons.length >= 5
      },
      {
        'id': 'ten_lessons',
        'name': 'Super élève',
        'condition': completedLessons.length >= 10
      },
      {'id': 'streak_3', 'name': 'Régularité', 'condition': currentStreak >= 3},
      {
        'id': 'streak_7',
        'name': 'Une semaine parfaite',
        'condition': currentStreak >= 7
      },
      {
        'id': 'level_5',
        'name': 'Niveau 5 atteint',
        'condition': level >= 5
      },
    ];

    for (var achievement in achievementsList) {
      if (achievement['condition'] as bool &&
          !achievements.contains(achievement['id'])) {
        achievements.add(achievement['id'] as String);
        return achievement['name'] as String;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'totalPoints': totalPoints,
        'completedLessons': completedLessons,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastActivity': lastActivity,
        'moduleProgress': moduleProgress.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        'achievements': achievements,
      };

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      level: json['level'] ?? 1,
      totalPoints: json['totalPoints'] ?? 0,
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastActivity: json['lastActivity'],
      moduleProgress: (json['moduleProgress'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              ModuleProgress.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserProgress.fromJsonString(String jsonString) {
    return UserProgress.fromJson(jsonDecode(jsonString));
  }
}

class ModuleProgress {
  int completed;
  int totalScore;
  int bestScore;

  ModuleProgress({
    this.completed = 0,
    this.totalScore = 0,
    this.bestScore = 0,
  });

  Map<String, dynamic> toJson() => {
        'completed': completed,
        'totalScore': totalScore,
        'bestScore': bestScore,
      };

  factory ModuleProgress.fromJson(Map<String, dynamic> json) {
    return ModuleProgress(
      completed: json['completed'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      bestScore: json['bestScore'] ?? 0,
    );
  }
}
