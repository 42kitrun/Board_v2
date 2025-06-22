import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class UserSurveyGraph extends StatefulWidget {
  const UserSurveyGraph({super.key});

  @override
  State<UserSurveyGraph> createState() => _UserSurveyGraphState();
}

class _UserSurveyGraphState extends State<UserSurveyGraph> {
  final List<Map<String, dynamic>> _surveyData = generateSurveyData();
  final ScrollController _horizontalController = ScrollController();
  static const double _columnWidth = 60.0;

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Survey Graph',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: _buildScrollableContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return Row(
      children: [
        _buildCategoryColumn(),
        Expanded(
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: Listener(
              onPointerSignal: (PointerSignalEvent event) {
                if (event is PointerScrollEvent) {
                  _handleScroll(event.scrollDelta.dy);
                }
              },
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  _handleScroll(-details.delta.dx);
                },
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: _surveyData.length * _columnWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _surveyData
                          .map((data) => SurveyDateColumn(data: data))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleScroll(double delta) {
    final newOffset = _horizontalController.offset + delta;
    _horizontalController.jumpTo(newOffset.clamp(
      0.0,
      _horizontalController.position.maxScrollExtent,
    ));
  }

  Widget _buildCategoryColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          ...[
            '신체',
            '영양',
            '마음',
            '수면',
          ].map((category) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Text(
                  category,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SurveyDateColumn extends StatelessWidget {
  final Map<String, dynamic> data;

  const SurveyDateColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data['date'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          ...['Physical', 'Nutrition', 'Mind', 'Sleep'].map((category) {
            return data.containsKey(category)
                ? SurveyResultCircle(
                    category: category,
                    value: data[category],
                  )
                : const SizedBox(height: 35);
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SurveyResultCircle extends StatelessWidget {
  final String category;
  final int value;

  const SurveyResultCircle({
    super.key,
    required this.category,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColorForCategory(category, value),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

Color getColorForCategory(String category, int value) {
  if (category == 'Physical' || category == 'Mind') {
    if (value <= 40) return const Color(0xFF18A0FB);
    if (value <= 60) return const Color(0xFF18A0FB).withOpacity(0.3);
    if (value <= 80) return const Color(0xFFFF7979).withOpacity(0.3);
    return const Color(0xFFFF7979);
  } else {
    if (value <= 40) return const Color(0xFFFF7979);
    if (value <= 60) return const Color(0xFFFF7979).withOpacity(0.3);
    if (value <= 80) return const Color(0xFF18A0FB).withOpacity(0.3);
    return const Color(0xFF18A0FB);
  }
}

List<Map<String, dynamic>> generateSurveyData() {
  final random = Random();
  final startDate = DateTime(2022, 1, 1);
  final endDate = DateTime(2024, 12, 31);

  List<DateTime> dates = List.generate(20, (_) {
    return startDate.add(
        Duration(days: random.nextInt(endDate.difference(startDate).inDays)));
  })
    ..sort();

  return dates.map((date) {
    Map<String, dynamic> dailyData = {
      'date':
          '${date.year}\n${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
    };
    for (var category in ['Physical', 'Nutrition', 'Mind', 'Sleep']) {
      if (random.nextBool()) {
        dailyData[category] = random.nextInt(69) + 30;
      }
    }
    return dailyData;
  }).toList();
}
