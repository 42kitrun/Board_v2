import 'package:flutter/material.dart';
import 'dart:math';

class UserGoalGraph extends StatelessWidget {
  UserGoalGraph({super.key});

  final Map<String, GoalData> goalData = {
    '신체': GoalData(color: Color(0xFFF8AC45)),
    '영양': GoalData(color: Color(0xFF6AAFA1)),
    '마음': GoalData(color: Color(0xFFE389B5)),
    '수면': GoalData(color: Color(0xFF8E91BE)),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
          child: Text(
            'Goal Graph',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          child: Row(
            children: goalData.entries
                .map((entry) => Expanded(
                    child: _buildCategoryWidget(entry.key, entry.value)))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _buildCategoryWidget(String category, GoalData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(category,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 12),
        _buildBarChart(data.thisMonth, data.color, _getCurrentMonthYear()),
        SizedBox(height: 35),
        _buildBarChart(
            data.lastMonth, data.color.withOpacity(0.5), _getLastMonthYear()),
      ],
    );
  }

  Widget _buildBarChart(double percentage, Color color, String dateLabel) {
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 30,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(dateLabel,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  String _getCurrentMonthYear() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  String _getLastMonthYear() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    return '${lastMonth.year}-${lastMonth.month.toString().padLeft(2, '0')}';
  }
}

class GoalData {
  final double lastMonth;
  final double thisMonth;
  final Color color;

  GoalData({required this.color})
      : lastMonth = Random().nextDouble() * 100,
        thisMonth = Random().nextDouble() * 100;
}
