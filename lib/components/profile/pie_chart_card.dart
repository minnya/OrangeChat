import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';

/// PieChartをCard付きで表示する関数ウィジェット
/// - title: Card下のテキスト
/// - centerLabel: PieChart中央に表示する文字
/// - sectionsData: [{"label": label, "value": value, "color": color}]
class PieChartCard extends StatelessWidget {
  final String title;
  final String centerLabel;
  final List<PieChartSectionData> sections;
  final double size;
  final double radius;
  final double centerSpaceRadius;
  final TextStyle centerTextStyle;

  const PieChartCard({
    super.key,
    required this.title,
    required this.centerLabel,
    required this.sections,
    this.size = 100,
    this.radius = 15,
    this.centerSpaceRadius = 30,
    this.centerTextStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  });
  @override
  Widget build(BuildContext context) {
    // 値がすべて0かどうかを判定
    final allZero = sections.every((s) => s.value == 0);
    // PieChartSectionData に変換
    final pieSections = allZero
        ? [
            PieChartSectionData(
              value: 100,
              color: Colors.black12,
              radius: radius,
              title: '',
              titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ]
        : sections.map((s) {
            return s.copyWith(
              radius: radius,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              title: s.title ?? "", // 必要に応じて空文字にする
            );
          }).toList();

    return Card(
      child: CustomContainer(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: pieSections,
                  ),
                ),
                Text(
                  centerLabel,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
