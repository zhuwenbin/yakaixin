import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 柱状图组件
/// 对应小程序: qiun-data-charts (type="column")
class ColumnChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final String? title;
  final Color barColor;
  final double maxY;

  const ColumnChartWidget({
    super.key,
    required this.data,
    this.title,
    this.barColor = const Color(0xFF2E68FF),
    this.maxY = 0,
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

    // 计算最大值
    final calculatedMaxY = maxY > 0
        ? maxY
        : data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      height: 200.h,
      padding: EdgeInsets.only(top: 30.h, right: 10.w, bottom: 10.h, left: 10.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 柱状图
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: calculatedMaxY,
                  minY: 0,
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
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              data[index].label,
                              style: TextStyle(
                                color: const Color(0xFF787E8F),
                                fontSize: 10.sp,
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
                        interval: calculatedMaxY / 4,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max || value == meta.min) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
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
                    horizontalInterval: calculatedMaxY / 4,
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
                      left: BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 1,
                      ),
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
                final leftPosition = (index * spacing) + (spacing - barWidth) / 2;
                final percentage = item.value / calculatedMaxY;
                final chartHeight = constraints.maxHeight - 40.h;
                final topPosition = (1 - percentage) * chartHeight - 20.h;
                
                return Positioned(
                  left: leftPosition,
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
                        fontSize: 11.sp,
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

  ChartData({
    required this.label,
    required this.value,
  });
}
