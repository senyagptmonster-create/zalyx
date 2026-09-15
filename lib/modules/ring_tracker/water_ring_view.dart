import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/zalyx_palette.dart';
import 'hydration_manager.dart';

class WaterRingView extends StatelessWidget {
  const WaterRingView({super.key});

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<HydrationManager>();
    final progress = manager.progressRatio;
    final percentInt = (progress * 100).round();
    final remaining = manager.remainingMl;
    final logs = manager.todayLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.water_drop_rounded, color: ZalyxPalette.azureBlue),
            SizedBox(width: 8),
            Text('Hydration Ring'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          const SizedBox(height: 8),

          // Central Circular Ring Dial
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 16,
                      backgroundColor: ZalyxPalette.borderLight.withValues(alpha: 0.5),
                      color: progress >= 1.0 ? ZalyxPalette.successTeal : ZalyxPalette.azureBlue,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        progress >= 1.0 ? Icons.check_circle_rounded : Icons.water_drop_rounded,
                        color: progress >= 1.0 ? ZalyxPalette.successTeal : ZalyxPalette.freshCyan,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$percentInt%',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: ZalyxPalette.deepOcean,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Text(
                        '${manager.todayTotalMl} / ${manager.dailyTargetMl} ml',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ZalyxPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Status & Remaining Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ZalyxPalette.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ZalyxPalette.borderLight),
              boxShadow: [
                BoxShadow(
                  color: ZalyxPalette.azureBlue.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ZalyxPalette.iceBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    remaining == 0 ? Icons.emoji_events_rounded : Icons.alarm_rounded,
                    color: remaining == 0 ? Colors.amber[700] : ZalyxPalette.azureBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remaining == 0
                            ? 'Daily Goal Achieved!'
                            : '$remaining ml to reach daily goal',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: ZalyxPalette.deepOcean,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        remaining == 0
                            ? 'Optimal cell hydration maintained. Great job!'
                            : 'Consistent sips throughout the afternoon boost focus.',
                        style: const TextStyle(fontSize: 12, color: ZalyxPalette.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Today's Intake Log Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TODAY\'S INTAKE TIMELINE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: ZalyxPalette.textMuted,
                ),
              ),
              Text(
                '${logs.length} entries',
                style: const TextStyle(fontSize: 12, color: ZalyxPalette.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Today's drink list
          if (logs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text(
                'No drinks logged today yet.\nUse Quick Log to register your first glass!',
                textAlign: TextAlign.center,
                style: TextStyle(color: ZalyxPalette.textMuted),
              ),
            )
          else
            ...logs.map((drink) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: ZalyxPalette.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ZalyxPalette.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ZalyxPalette.iceBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_drink_rounded, color: ZalyxPalette.azureBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drink.beverageType,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            _formatTime(drink.timestamp),
                            style: const TextStyle(fontSize: 11, color: ZalyxPalette.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${drink.amountMl} ml',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: ZalyxPalette.azureBlue,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18, color: ZalyxPalette.textMuted),
                      onPressed: () => manager.removeLog(drink.id),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
