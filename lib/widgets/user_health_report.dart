import 'package:flutter/material.dart';
import 'dart:core';

class UserHealthReport extends StatefulWidget {
  const UserHealthReport({super.key});

  @override
  State<UserHealthReport> createState() => _UserHealthReportState();
}

class _UserHealthReportState extends State<UserHealthReport> {
  final List<DateTime> _reportDates = [
    DateTime(2024, 2, 9),
    DateTime(2023, 10, 30),
    DateTime(2023, 5, 16),
    DateTime(2023, 1, 8),
    DateTime(2022, 9, 15),
  ];

  late Map<DateTime, TextEditingController> _textControllers;
  late Map<DateTime, DateTime> _lastModifiedDates;
  late Map<DateTime, String> _lifestyleTexts;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _textControllers = {};
    _lastModifiedDates = {};
    _lifestyleTexts = {
      DateTime(2024, 2, 9): '''
신체: 균형 잡힌 스트레칭으로 유연성을 높이세요. 전신 스트레칭을 통해 근육의 경직을 풀고 부상 위험을 줄일 수 있습니다.

영양: 프로바이오틱스 섭취를 늘리세요. 요구르트, 키피어 등 발효식품으로 장 건강을 개선하고 면역력을 높입니다.

마음: 사회적 관계를 강화하세요. 친구, 가족과의 대화와 소통을 통해 정서적 지지를 받고 긍정적인 에너지를 얻습니다.

수면: 수면 환경을 최적화하세요. 적정 온도, 습도 조절, 편안한 침구 선택으로 깊고 편안한 수면을 취할 수 있습니다.
''',
      DateTime(2023, 10, 30): '''
신체: 유산소 운동을 꾸준히 하세요. 자전거 타기, 수영, 조깅 등으로 심폐지구력을 향상시키고 체지방을 감소시킬 수 있습니다.

영양: 항산화 식품을 섭취하세요. 베리류, 녹차, 견과류 등 항산화 성분이 풍부한 음식으로 세포 건강을 보호합니다.

마음: 명상과 호흡 운동을 실천하세요. 깊은 호흡과 마음 챙김 명상으로 정서적 안정과 집중력을 높일 수 있습니다.

수면: 수면 전 루틴을 만드세요. 따뜻한 목욕, 독서, 부드러운 음악 등으로 심신을 이완시키고 양질의 수면을 유도합니다.
''',
      DateTime(2023, 5, 16): '''
신체: 근력 운동을 통해 근육 건강을 강화하세요. 주 3회 웨이트 트레이닝으로 근육량을 증가시키고 기초대사량을 높일 수 있습니다.

영양: 단백질 섭취를 최적화하세요. 살코기, 생선, 달걀, 콩류 등 양질의 단백질 공급원을 균형 있게 섭취하여 근육 회복을 돕습니다.

마음: 감사 일기를 작성하세요. 매일 3가지 감사한 일을 기록하며 긍정적인 마인드를 키우고 스트레스를 줄일 수 있습니다.

수면: 낮잠의 길이를 조절하세요. 20-30분의 짧은 낮잠으로 피로를 회복하고 밤잠의 질을 해치지 않도록 관리합니다.
''',
      DateTime(2023, 1, 8): '''
신체: 스트레칭과 요가를 통해 유연성을 높이세요. 매일 아침 10분 스트레칭으로 근육의 긴장을 풀고 관절 가동 범위를 넓힐 수 있습니다.

영양: 수분 섭취를 늘리고 가공식품을 줄이세요. 하루 2리터 이상의 물을 마시고, 신선한 재료로 조리한 음식을 선택하여 건강을 지킵니다.

마음: 긍정적인 자기 대화를 연습하세요. 부정적인 생각 대신 격려와 희망의 메시지를 스스로에게 전달하며 자존감을 높입니다.

수면: 취침 전 전자기기 사용을 줄이세요. 블루라이트를 차단하고 조용하고 어두운 환경을 만들어 수면의 질을 개선합니다.
''',
      DateTime(2022, 9, 15):
          '''신체: 규칙적인 운동으로 근력과 지구력을 향상시키세요. 매일 30분 이상 걷기나 조깅을 통해 심폐기능을 강화하고 근육량을 늘릴 수 있습니다.

영양: 균형 잡힌 식단을 통해 영양 섭취를 최적화하세요. 신선한 채소와 과일, 단백질, 통곡물을 골고루 섭취하여 건강한 식습관을 만들어갑니다.

마음: 스트레스 관리와 명상을 통해 정신 건강을 돌보세요. 매일 10분 이상 깊은 호흡과 마음 챙김 명상으로 심리적 안정을 찾을 수 있습니다.

수면: 규칙적인 수면 패턴을 유지하세요. 매일 같은 시간에 자고 일어나며, 충분한 수면 시간(7-8시간)을 확보하여 신체 회복력을 높입니다.''',
    };

    for (var date in _reportDates) {
      _textControllers[date] =
          TextEditingController(text: _lifestyleTexts[date] ?? '');
      _lastModifiedDates[date] = date;
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildHeader()),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: Column(
              children: [
                Expanded(flex: 3, child: _buildReportList()),
                SizedBox(
                  height: 8,
                ),
                Expanded(flex: 7, child: _buildEditor()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      'Health Report',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildReportList() {
    return ListView.builder(
      itemCount: _reportDates.length,
      itemBuilder: (context, index) {
        final date = _reportDates[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_formatDate(date)),
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '변경일자 ${_formatDate(_lastModifiedDates[date] ?? date)}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          onTap: () => setState(() {
            _selectedDate = date;
            _textControllers[date]?.text = _lifestyleTexts[date] ?? '';
          }),
          selected: _selectedDate == date,
        );
      },
    );
  }

  Widget _buildEditor() {
    if (_selectedDate == null) {
      return const Center(child: Text('Select a date to edit'));
    }

    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: _textControllers[_selectedDate],
            textAlign: TextAlign.justify,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              hintText: '텍스트를 입력하세요...',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('저장'),
              ),
              ElevatedButton(
                onPressed: _deleteReport,
                child: const Text('삭제'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    if (_selectedDate != null) {
      setState(() {
        _lifestyleTexts[_selectedDate!] =
            _textControllers[_selectedDate!]?.text ?? '';
        _lastModifiedDates[_selectedDate!] = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('변경사항이 저장되었습니다.')),
      );
    }
  }

  void _deleteReport() {
    if (_selectedDate != null) {
      setState(() {
        _reportDates.remove(_selectedDate);
        _textControllers.remove(_selectedDate);
        _lastModifiedDates.remove(_selectedDate);
        _lifestyleTexts.remove(_selectedDate);
        _selectedDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리포트가 삭제되었습니다.')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
