import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/zalyx_palette.dart';
import '../ring_tracker/hydration_manager.dart';

class WeeklyChartView extends StatelessWidget {
  const WeeklyChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<HydrationManager>();
    final records = manager.weeklyRecords;
    final target = manager.dailyTargetMl;

    final totalMl = records.fold(0, (sum, r) => sum + r.totalMl);
    final avgDailyMl = records.isEmpty ? 0 : (totalMl / records.length).round();
    final daysAchieved = records.where((r) => r.totalMl >= r.targetMl).length;
    final bestDay = records.isEmpty
        ? null
        : records.reduce((curr, next) => curr.totalMl > next.totalMl ? curr : next);

    const maxChartMl = 3500;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: ZalyxPalette.azureBlue),
            SizedBox(width: 8),
            Text('Weekly Hydration Analytics'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Weekly Bar Chart Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ZalyxPalette.cardSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ZalyxPalette.borderLight),
              boxShadow: [
                BoxShadow(
                  color: ZalyxPalette.azureBlue.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '7-DAY INTAKE VOLUME',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: ZalyxPalette.textMuted,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ZalyxPalette.iceBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Target: ${target}ml',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ZalyxPalette.azureBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Visual Bars
                SizedBox(
                  height: 180,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: records.map((record) {
                      final ratio = (record.totalMl / maxChartMl).clamp(0.05, 1.0);
                      final isTargetMet = record.totalMl >= target;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(record.totalMl / 1000).toStringAsFixed(1)}L',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isTargetMet ? ZalyxPalette.successTeal : ZalyxPalette.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 24,
                            height: 130 * ratio,
                            decoration: BoxDecoration(
                              color: isTargetMet
                                  ? ZalyxPalette.successTeal
                                  : (record.totalMl >= target * 0.8
                                      ? ZalyxPalette.azureBlue
                                      : ZalyxPalette.borderLight),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            record.dayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ZalyxPalette.deepOcean,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4 Summary Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'WEEKLY TOTAL',
                  value: '${(totalMl / 1000).toStringAsFixed(1)} L',
                  color: ZalyxPalette.azureBlue,
                  icon: Icons.water_drop_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  title: 'DAILY AVERAGE',
                  value: '$avgDailyMl ml',
                  color: ZalyxPalette.freshCyan,
                  icon: Icons.speed_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'GOAL SUCCESS',
                  value: '$daysAchieved / ${records.length} Days',
                  color: ZalyxPalette.successTeal,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  title: 'PEAK DAY',
                  value: bestDay != null ? '${bestDay.dayName} (${bestDay.totalMl}ml)' : '--',
                  color: Colors.amber[800]!,
                  icon: Icons.emoji_events_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Science Tip Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ZalyxPalette.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ZalyxPalette.borderLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: ZalyxPalette.azureBlue, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Circadian Hydration Consistency',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: ZalyxPalette.deepOcean),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Drinking at least 500ml within 30 minutes of waking up immediately restarts cellular metabolism and replenishes overnight respiratory moisture loss.',
                        style: TextStyle(fontSize: 12, color: ZalyxPalette.textSecondary, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZalyxPalette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZalyxPalette.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: ZalyxPalette.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
