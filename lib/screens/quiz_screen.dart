import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/lesson_content.dart';
import '../widgets/answer_button.dart';
import '../widgets/modern_button.dart';
import '../widgets/celebration_widget.dart';

class QuizScreen extends StatefulWidget {
  final Lesson lesson;
  final String moduleId;

  const QuizScreen({
    Key? key,
    required this.lesson,
    required this.moduleId,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<AnswerState> _answerStates = [];
  bool _answered = false;
  bool _showCelebration = false;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _answerStates = List.filled(widget.lesson.questions[0].options.length, AnswerState.normal);
  }

  void _checkAnswer(String selectedAnswer, int index) {
    if (_answered) return;

    setState(() {
      _answered = true;
      final correctAnswer = widget.lesson.questions[_currentQuestionIndex].answer.toLowerCase();
      
      if (selectedAnswer.toLowerCase() == correctAnswer) {
        _answerStates[index] = AnswerState.correct;
        _feedback = '✅ Excellent!';
        _score += 25;
        _showCelebration = true;
        
        final appState = Provider.of<AppState>(context, listen: false);
        appState.audioService.speak(selectedAnswer);
      } else {
        _answerStates[index] = AnswerState.wrong;
        final correctIndex = widget.lesson.questions[_currentQuestionIndex].options
            .indexWhere((opt) => opt.toLowerCase() == correctAnswer);
        if (correctIndex != -1) {
          _answerStates[correctIndex] = AnswerState.correct;
        }
        _feedback = '❌ The answer is: ${correctAnswer.toUpperCase()}';
      }
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _showCelebration = false;
      if (_currentQuestionIndex < widget.lesson.questions.length - 1) {
        _currentQuestionIndex++;
        _answered = false;
        _feedback = '';
        _answerStates = List.filled(
          widget.lesson.questions[_currentQuestionIndex].options.length,
          AnswerState.normal,
        );
      } else {
        _showResults();
      }
    });
  }

  void _showResults() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final totalPoints = widget.lesson.questions.length * 25;
    final percentage = (_score / totalPoints * 100).round();
    
    String encouragement = await appState.aiService.getEncouragement(_score, totalPoints);
    
    appState.completeLesson(widget.lesson.id, widget.moduleId, _score);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score/$totalPoints',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              encouragement,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _answered = false;
                _feedback = '';
                _answerStates = List.filled(
                  widget.lesson.questions[0].options.length,
                  AnswerState.normal,
                );
              });
            },
            child: const Text('🔄 Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('🏠 Menu'),
          ),
        ],
      ),
    );
  }

  void _speakQuestion() {
    final appState = Provider.of<AppState>(context, listen: false);
    final question = widget.lesson.questions[_currentQuestionIndex].question;
    appState.audioService.speak(question);
  }

  void _showHint() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final question = widget.lesson.questions[_currentQuestionIndex];
    
    final hint = await appState.aiService.getHint(question.question, question.answer);
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💡 Hint'),
        content: Text(hint, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.lesson.questions[_currentQuestionIndex];
    final options = List<String>.from(question.options)..shuffle();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${widget.lesson.questions.length}'),
        backgroundColor: const Color(0xFF3366CC),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.emoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ModernButton(
                        text: '🔊 Listen',
                        onPressed: _speakQuestion,
                        backgroundColor: const Color(0xFF2196F3),
                        fontSize: 14,
                        isSmall: true,
                      ),
                      const SizedBox(width: 12),
                      ModernButton(
                        text: '💡 Hint',
                        onPressed: _showHint,
                        backgroundColor: const Color(0xFFFF9800),
                        fontSize: 14,
                        isSmall: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_feedback.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _feedback.startsWith('✅')
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _feedback,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _feedback.startsWith('✅')
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return AnswerButton(
                          text: options[index].toUpperCase(),
                          onPressed: () => _checkAnswer(options[index], index),
                          state: _answerStates[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showCelebration) const CelebrationWidget(),
        ],
      ),
    );
  }
}
