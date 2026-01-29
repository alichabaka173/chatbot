import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/lesson_content.dart';
import '../widgets/modern_button.dart';
import 'dart:math';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            if (appState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildStats(appState),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildModulesGrid(context, appState),
                  ),
                  const SizedBox(height: 20),
                  _buildBottomButtons(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        '🌟 English Learning Adventure 🌟',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3366CC),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStats(AppState appState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Level', '${appState.progress.level}', Icons.star),
          _buildStatItem('Points', '${appState.progress.totalPoints}', Icons.emoji_events),
          _buildStatItem('Streak', '${appState.progress.currentStreak} 🔥', Icons.local_fire_department),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF3366CC), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, AppState appState) {
    final modules = appState.getAvailableModules();
    final random = Random(42);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        final colors = [
          const Color(0xFF6B9BD1),
          const Color(0xFF8BC34A),
          const Color(0xFFFF9800),
          const Color(0xFFE91E63),
          const Color(0xFF9C27B0),
          const Color(0xFF00BCD4),
        ];
        final color = colors[index % colors.length];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/lessons',
              arguments: module.id,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  module.icon,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                Text(
                  module.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ModernButton(
            text: '💬 AI Tutor',
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            backgroundColor: const Color(0xFFFF9800),
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ModernButton(
            text: '📊 Progress',
            onPressed: () => Navigator.pushNamed(context, '/progress'),
            backgroundColor: const Color(0xFF4CAF50),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
