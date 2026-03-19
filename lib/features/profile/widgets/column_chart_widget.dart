import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 与小程序 uCharts 一致的 Y 轴范围圆整（findRange）
double _findRange(double num, String type, double limit) {
  if (num.isNaN) return num;
  double l = limit;
  double multiple = 1.0;
  while (l < 1) {
    l *= 10;
    multiple *= 10;
  }
  int limitInt = l.round();
  int numScaled = type == 'upper'
      ? (num * multiple).ceil()
      : (num * multiple).floor();
  while (numScaled % limitInt != 0) {
    if (type == 'upper') {
      numScaled++;
    } else {
      numScaled--;
    }
  }
  return numScaled / multiple;
}

/// 与小程序 uCharts 一致的步长基数（getDataRange）
({double minRange, double maxRange}) _getDataRange(
  double minData,
  double maxData,
) {
  double range = maxData - minData;
  double limit = 0.000001;
  if (range >= 10000) {
    limit = 1000;
  } else if (range >= 1000) {
    limit = 100;
  } else if (range >= 100) {
    limit = 10;
  } else if (range >= 10) {
    limit = 5;
  } else if (range >= 1) {
    limit = 1;
  } else if (range >= 0.1) {
    limit = 0.1;
  } else if (range >= 0.01) {
    limit = 0.01;
  } else if (range >= 0.001) {
    limit = 0.001;
  } else if (range >= 0.0001) {
    limit = 0.0001;
  } else if (range >= 0.00001) {
    limit = 0.00001;
  }
  return (
    minRange: _findRange(minData, 'lower', limit),
    maxRange: _findRange(maxData, 'upper', limit),
  );
}

/// 数值标签位置：柱顶正上方 或 0 刻度线（底部）
enum ChartValueLabelPosition {
  aboveBar, // 刷题量：数字在柱状图正上方
  onBaseline, // 学习时长：数字在 0 刻度线上
}

/// 柱状图组件
/// 对应小程序: qiun-data-charts (type="column")，Y 轴规则见 column_chart_yaxis_rule.md
class ColumnChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final String? title;
  final Color barColor;
  final double maxY;

  /// 数值标签位置：aboveBar=柱顶正上方，onBaseline=0刻度线
  final ChartValueLabelPosition valueLabelPosition;

  /// 与小程序 uCharts 默认一致：splitNumber = 5 → 6 个刻度、等间隔
  static const int _leftAxisSplitNumber = 5;

  const ColumnChartWidget({
    super.key,
    required this.data,
    this.title,
    this.barColor = const Color(0xFF2E68FF),
    this.maxY = 0,
    this.valueLabelPosition = ChartValueLabelPosition.aboveBar,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 150.h,
        alignment: Alignment.center,
        child: Text(
          '暂无任何数据！',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFFCCCCCC)),
        ),
      );
    }

    double minData = 0;
    double maxData = 0;
    if (data.isNotEmpty) {
      minData = data.map((e) => e.value).reduce(math.min);
      maxData = data.map((e) => e.value).reduce(math.max);
    }
    if (minData == maxData) {
      if (maxData == 0) {
        maxData = 10;
      } else {
        minData = 0;
      }
    }
    if (maxY > 0) {
      maxData = maxY;
    }
    final range = _getDataRange(minData, maxData);
    final minRange = range.minRange;
    final maxRange = range.maxRange;
    final span = maxRange - minRange;
    final calculatedMaxY = span > 0 ? maxRange : 1.0;
    final calculatedMinY = minRange;
    final leftAxisInterval = span > 0 ? span / _leftAxisSplitNumber : 0.2;

    // 顶部留足空间，避免柱子顶部数值标签被裁切（最高柱时标签在柱子上方约 20.h）
    final topPadding = 44.h;
    return Container(
      height: 200.h,
      padding: EdgeInsets.only(
        top: topPadding,
        right: 10.w,
        bottom: 10.h,
        left: 10.w,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 柱状图
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: calculatedMaxY,
                  minY: calculatedMinY,
                  barTouchData: BarTouchData(
                    enabled: false, // 禁用触摸提示，使用自定义顶部标签
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.h,
                            child: Center(
                              child: Text(
                                data[index].label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF787E8F),
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          );
                        },
                        reservedSize: 30.h,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40.w,
                        interval: leftAxisInterval,
                        getTitlesWidget: (value, meta) {
                          // 与小程序一致：整数不保留小数，非整数保留一位小数（如 0.3, 0.6, 0.9）
                          final formattedValue =
                              value == value.truncateToDouble()
                              ? value.toInt().toString()
                              : value.toStringAsFixed(1);
                          return Text(
                            formattedValue,
                            style: TextStyle(
                              color: const Color(0xFF787E8F),
                              fontSize: 10.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: leftAxisInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFE5E5E5),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                      bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                    ),
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.value,
                          color: barColor,
                          width: 28.w, // 增加柱子宽度
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: false,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // 柱子顶部数值标签
              ...data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final barWidth = 28.w;
                final totalWidth = constraints.maxWidth;
                final spacing = totalWidth / data.length;
                final leftPosition =
                    (index * spacing) + (spacing - barWidth) / 2;
                final chartHeight = constraints.maxHeight - 40.h;
                final rangeSpan = calculatedMaxY - calculatedMinY;
                final percentage = rangeSpan > 0
                    ? (item.value - calculatedMinY) / rangeSpan
                    : item.value / calculatedMaxY;
                final topPosition =
                    valueLabelPosition == ChartValueLabelPosition.onBaseline
                    ? chartHeight - 14.h
                    : (1 - percentage) * chartHeight - 20;

                return Positioned(
                  left: leftPosition.toDouble(),
                  top: topPosition,
                  child: Container(
                    width: barWidth,
                    alignment: Alignment.center,
                    child: Text(
                      item.value % 1 == 0
                          ? item.value.toInt().toString()
                          : item.value.toStringAsFixed(2),
                      style: TextStyle(
                        color: barColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

/// 图表数据模型
class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}
