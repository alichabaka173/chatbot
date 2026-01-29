import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/menu_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/progress_screen.dart';
import 'models/lesson_content.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'English Learning Adventure',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFF5F7FF),
        ),
        home: const MenuScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/lessons':
              final moduleId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => LessonsScreen(moduleId: moduleId),
              );
            
            case '/quiz':
              final args = settings.arguments as Map<String, dynamic>;
              final lesson = args['lesson'] as Lesson;
              final moduleId = args['moduleId'] as String;
              return MaterialPageRoute(
                builder: (context) => QuizScreen(
                  lesson: lesson,
                  moduleId: moduleId,
                ),
              );
            
            case '/chat':
              return MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              );
            
            case '/progress':
              return MaterialPageRoute(
                builder: (context) => const ProgressScreen(),
              );
            
            default:
              return MaterialPageRoute(
                builder: (context) => const MenuScreen(),
              );
          }
        },
      ),
    );
  }
}
