import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';

class UserFatigueGraph extends StatefulWidget {
  const UserFatigueGraph({super.key});

  @override
  State<UserFatigueGraph> createState() => _UserFatigueGraphState();
}

class _UserFatigueGraphState extends State<UserFatigueGraph> {
  // Constants
  static const int _maxZoomLevel = 6;
  static const double _visibleRange = 21;
  static const int _totalDays = 180;
  static const int _weekInterval = 7;
  static const int _monthInterval = 30;

  // Data
  late final List<FlSpot> _dailyFatigueSpots;
  late List<FlSpot> _weeklyFatigueSpots;
  late List<FlSpot> _monthlyFatigueSpots;

  // View State
  double _minX = 0;
  double _maxX = _visibleRange;
  int _zoomLevel = 1;

  // Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollController();
  }

  void _initializeData() {
    _dailyFatigueSpots = _generateDailyData();
    _calculateAggregatedData();
    _initializeGraphView();
  }

  void _updateGraphPosition(double delta) {
    final currentData = _getCurrentData();
    final visibleRange = _visibleRange / _getCurrentScale();
    final newMinX = (_minX + delta * 0.1)
        .clamp(0.0, max(0.0, currentData.length - visibleRange));
    final newMaxX = min(newMinX + visibleRange, currentData.length.toDouble());

    setState(() {
      _minX = newMinX.toDouble();
      _maxX = newMaxX;
    });

    _synchronizeScrollPosition();
  }

  void _setupScrollController() {
    _scrollController.addListener(_handleScrollbarMove);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _synchronizeScrollPosition();
    });
  }

  List<FlSpot> _generateDailyData() {
    return List.generate(_totalDays, (index) {
      return FlSpot(index.toDouble(), (Random().nextInt(9) + 1).toDouble());
    });
  }

  void _calculateAggregatedData() {
    _weeklyFatigueSpots = _aggregateData(_dailyFatigueSpots, 7);
    _monthlyFatigueSpots = _aggregateData(_dailyFatigueSpots, 30);
  }

  List<FlSpot> _aggregateData(List<FlSpot> data, int interval) {
    List<FlSpot> aggregatedData = [];
    for (int i = 0; i < data.length; i += interval) {
      double sum = 0;
      int count = 0;
      for (int j = i; j < i + interval && j < data.length; j++) {
        sum += data[j].y;
        count++;
      }
      if (count > 0) {
        aggregatedData
            .add(FlSpot(aggregatedData.length.toDouble(), sum / count));
      }
    }
    return aggregatedData;
  }

  void _initializeGraphView() {
    _zoomLevel = 3; // 초기 줌 레벨을 3(일별 보기)으로 설정
    _updateViewRange();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _synchronizeScrollPosition());
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll <= 0) return;

    final currentData = _getCurrentData();
    final visibleRange = _visibleRange / _getCurrentScale();

    final scrollRatio = scrollPosition / maxScroll;
    final newMinX = scrollRatio * (currentData.length - visibleRange);

    setState(() {
      _minX = newMinX;
      _maxX = newMinX + visibleRange;
    });
  }

  void _handleMouseWheel(PointerScrollEvent event) {
    if (_needsScroll()) {
      _updateGraphPosition(event.scrollDelta.dy * 0.1);
    }
  }

  void _handlePanZoomUpdate(PointerPanZoomUpdateEvent event) {
    if (_needsScroll()) {
      _updateGraphPosition(-event.delta.dx * 0.1);
    }
  }

  void _handleScrollbarMove() {
    if (!_scrollController.hasClients) return;

    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll <= 0) return;

    final currentData = _getCurrentData();
    final visibleRange = _visibleRange / _getCurrentScale();
    final scrollRatio = scrollPosition / maxScroll;
    final newMinX = scrollRatio * (currentData.length - visibleRange);

    setState(() {
      _minX = newMinX;
      _maxX = newMinX + visibleRange;
    });
  }

  void _updateRange(double delta) {
    final currentData = _getCurrentData();
    final visibleRange = _visibleRange / _getCurrentScale();
    final newMinX =
        (_minX + delta).clamp(0.0, max(0.0, currentData.length - visibleRange));
    final newMaxX = min(newMinX + visibleRange, currentData.length.toDouble());

    setState(() {
      _minX = newMinX.toDouble();
      _maxX = newMaxX;
    });

    _synchronizeScrollPosition();
  }

  void _synchronizeScrollPosition() {
    if (!_scrollController.hasClients) return;

    final currentData = _getCurrentData();
    final totalRange = currentData.length.toDouble();
    final visibleRange = _visibleRange / _getCurrentScale();

    if (totalRange <= visibleRange) {
      _scrollController.jumpTo(0);
      return;
    }

    final scrollRatio = _minX / (totalRange - visibleRange);
    final targetScroll =
        scrollRatio * _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      targetScroll.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
    );
  }

  // Zoom Management Methods
  void _zoomIn() {
    if (_zoomLevel <= 1) return;
    setState(() {
      _zoomLevel--;
      _updateViewRange();
    });
    _synchronizeScrollPosition();
  }

  void _zoomOut() {
    if (_zoomLevel >= _maxZoomLevel) return;
    setState(() {
      _zoomLevel++;
      _updateViewRange();
    });
    _synchronizeScrollPosition();
  }

  void _updateViewRange() {
    final currentData = _getCurrentData();
    final scale = _getCurrentScale();
    final visibleRange = _visibleRange / scale;

    setState(() {
      _minX = _minX.clamp(0.0, max(0.0, currentData.length - visibleRange));
      _maxX = min(_minX + visibleRange, currentData.length.toDouble());
    });
  }

  // 스크롤바 너비 계산 메서드 수정
  double _calculateScrollWidth(BuildContext context) {
    final baseWidth = MediaQuery.of(context).size.width - 240;
    final currentData = _getCurrentData();
    final scale = _getCurrentScale();
    final visiblePoints = _visibleRange / scale;

    // 데이터 길이가 화면에 표시 가능한 포인트 수보다 작으면 기본 너비 반환
    if (currentData.length <= visiblePoints) {
      return baseWidth;
    }

    return max(baseWidth * (currentData.length / visiblePoints), baseWidth);
  }

  // Utility Methods
  List<FlSpot> _getCurrentData() {
    if (_zoomLevel <= 3) {
      return _dailyFatigueSpots;
    } else if (_zoomLevel <= 5) {
      return _weeklyFatigueSpots;
    } else {
      return _monthlyFatigueSpots;
    }
  }

  // 수정된 _getCurrentScale 메서드
  double _getCurrentScale() {
    // zoomLevel은 1부터 시작하므로, 배열 인덱스로 변환 시 주의
    final List<double> scales = [4.0, 2.0, 1.0, 2.0, 1.5, 2.0];
    final int index = (_zoomLevel - 1).clamp(0, scales.length - 1);
    return scales[index];
  }

  String _getFormattedDate(double value) {
    final currentData = _getCurrentData();
    int index = value.toInt();
    if (index < 0 || index >= currentData.length) return '';

    final startDate = DateTime(2024, 1, 1);
    final date = startDate.add(Duration(days: index * _getDateInterval()));
    return _formatDateByZoomLevel(date);
  }

  String _formatDateByZoomLevel(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');

    if (_zoomLevel <= 3) {
      final day = date.day.toString().padLeft(2, '0');
      return '$year\n$month-$day';
    } else if (_zoomLevel <= 5) {
      final weekNumber = ((date.day - 1) ~/ 7) + 1;
      return '$year\n$month-W$weekNumber';
    }
    return '$year-$month';
  }

  int _getDateInterval() {
    if (_zoomLevel <= 3) return 1;
    if (_zoomLevel <= 5) return _weekInterval;
    return _monthInterval;
  }

  String _getViewModeText() {
    if (_zoomLevel <= 3) return '일\n별';
    if (_zoomLevel <= 5) return '주\n별';
    return '월\n별';
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤이 필요한지 확인하는 메서드 추가
  bool _needsScroll() {
    final currentData = _getCurrentData();
    final visibleRange = _visibleRange / _getCurrentScale();
    return currentData.length > visibleRange;
  }

  Widget _buildScrollbar(BuildContext context) {
    final currentData = _getCurrentData();
    final visiblePoints = _visibleRange / _getCurrentScale();

    // 데이터 길이가 화면에 표시 가능한 포인트 수보다 작으면 스크롤바 미표시
    if (currentData.length <= visiblePoints) {
      return const SizedBox(height: 30);
    }

    return SizedBox(
      height: 30,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            width: _calculateScrollWidth(context),
            height: 30,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fatigue Graph',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(
              height: 275,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 0),
                      child: ClipRect(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width - 240,
                          child: Listener(
                            onPointerSignal: (pointerSignal) {
                              if (pointerSignal is PointerScrollEvent) {
                                if (pointerSignal.scrollDelta.dy != 0) {
                                  _handleMouseWheel(pointerSignal);
                                } else if (pointerSignal.scrollDelta.dx != 0) {
                                  _updateGraphPosition(
                                      pointerSignal.scrollDelta.dx * 0.1);
                                }
                              }
                            },
                            onPointerPanZoomUpdate: _handlePanZoomUpdate,
                            child: LineChart(
                              LineChartData(
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    tooltipBgColor:
                                        Colors.blueAccent.withOpacity(0.8),
                                    tooltipMargin: 0,
                                    tooltipPadding: const EdgeInsets.all(8),
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: true,
                                    getTooltipItems:
                                        (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        return LineTooltipItem(
                                          '피로도: ${spot.y.toInt()}',
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 2,
                                  verticalInterval: 1,
                                  checkToShowHorizontalLine: (value) =>
                                      value <= 10,
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 35,
                                      getTitlesWidget: (value, meta) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 5,
                                          child: Text(
                                            _getFormattedDate(value),
                                            style: const TextStyle(fontSize: 9),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        if (value > 10) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Text(
                                            value.toInt().toString(),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: true),
                                minX: _minX,
                                maxX: _maxX,
                                minY: 0,
                                maxY: 10.5,
                                clipData: FlClipData.all(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _getCurrentData(),
                                    isCurved: true,
                                    color: Colors.blue,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(milliseconds: 150),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: _buildScrollbar(context),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 6,
              top: 8,
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getViewModeText(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.zoom_in, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _zoomIn,
                      ),
                      const SizedBox(height: 5),
                      IconButton(
                        icon: const Icon(Icons.zoom_out, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _zoomOut,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
