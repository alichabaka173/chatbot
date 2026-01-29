import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String apiKey = 'AIzaSyBoTJFRccRK40MEaxQD0eeQJ1pyHJ5eYtw';
  late final GenerativeModel _model;
  
  AIService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
    );
  }

  Future<String> chat(String userMessage, {int? level, String? topic}) async {
    try {
      final systemPrompt = '''You are a friendly English teacher for children aged 5-10 years old.
Your role is to:
- Help children learn English in a fun and engaging way
- Use simple words and short sentences
- Be encouraging and positive
- Correct mistakes gently
- Use emojis to make learning fun
- Adapt to the child's level
- Answer questions about English words, grammar, and pronunciation
- Create simple exercises when asked

Always respond in a way that's appropriate for young children.
Keep responses short and clear.
Use examples they can relate to (animals, toys, family, food, etc.).

${level != null ? 'Child\'s current level: $level\n' : ''}${topic != null ? 'Current topic: $topic\n' : ''}
Child says: $userMessage

Respond in a friendly, educational way:''';

      final content = [Content.text(systemPrompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? 'Sorry, I had trouble understanding. Try again! 😊';
    } catch (e) {
      print('AI Error: $e');
      return 'Oops! I had a little problem 😅 Can you try again?';
    }
  }

  Future<String> getHint(String question, String correctAnswer) async {
    try {
      final prompt = '''A child is learning English and struggling with this question:
Question: $question
Correct answer: $correctAnswer

Give a helpful hint (not the answer!) in simple English that a 5-10 year old can understand.
Use an emoji and keep it to one short sentence.''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? 'Think about what you know! You can do it! 💪';
    } catch (e) {
      print('Hint Error: $e');
      return 'Think about what you know! You can do it! 💪';
    }
  }

  Future<String> getEncouragement(int score, int total) async {
    try {
      final percentage = (score / total * 100).round();
      final prompt = '''A child just completed a quiz and got $score out of $total points ($percentage%).
Give them encouraging feedback in one short sentence with an emoji.
Be positive and motivating!''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? _getDefaultEncouragement(percentage);
    } catch (e) {
      print('Encouragement Error: $e');
      return _getDefaultEncouragement((score / total * 100).round());
    }
  }

  String _getDefaultEncouragement(int percentage) {
    if (percentage >= 80) {
      return 'Amazing work! You\'re a star! ⭐';
    } else if (percentage >= 60) {
      return 'Great job! Keep practicing! 🌟';
    } else {
      return 'Good try! Practice makes perfect! 💪';
    }
  }

  Future<String> explainWord(String word) async {
    try {
      final prompt = '''Explain the English word '$word' to a child aged 5-10 years old.
Include:
- Simple definition
- An example sentence
- A fun fact or emoji
Keep it very short and simple!''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? 'The word \'$word\' is a great English word! Keep learning! 🌟';
    } catch (e) {
      print('Explain Error: $e');
      return 'The word \'$word\' is a great English word! Keep learning! 🌟';
    }
  }
}
