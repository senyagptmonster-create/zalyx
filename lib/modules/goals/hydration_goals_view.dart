import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/zalyx_palette.dart';
import '../ring_tracker/hydration_manager.dart';

class HydrationGoalsView extends StatefulWidget {
  const HydrationGoalsView({super.key});

  @override
  State<HydrationGoalsView> createState() => _HydrationGoalsViewState();
}

class _HydrationGoalsViewState extends State<HydrationGoalsView> {
  late double _weightKg;
  late String _activity;
  bool _isHotClimate = false;

  @override
  void initState() {
    super.initState();
    final manager = context.read<HydrationManager>();
    _weightKg = manager.userWeightKg;
    _activity = manager.activityLevel;
  }

  int _calculateRecommendedTarget() {
    // 35ml per kg base
    final base = (_weightKg * 35).round();
    int activityBonus = 0;
    if (_activity == 'Moderate') activityBonus = 400;
    if (_activity == 'Intense') activityBonus = 850;
    int climateBonus = _isHotClimate ? 450 : 0;
    return base + activityBonus + climateBonus;
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<HydrationManager>();
    final recommended = _calculateRecommendedTarget();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.tune_rounded, color: ZalyxPalette.azureBlue),
            SizedBox(width: 8),
            Text('Hydration Goals & Biology'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Quota Manual Adjustment Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ZalyxPalette.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ZalyxPalette.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daily Water Quota',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ZalyxPalette.deepOcean,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: ZalyxPalette.azureBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${manager.dailyTargetMl} ml',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: ZalyxPalette.azureBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: manager.dailyTargetMl.toDouble(),
                    min: 1200,
                    max: 4500,
                    divisions: 33,
                    activeColor: ZalyxPalette.azureBlue,
                    onChanged: (val) => manager.setDailyTarget(val.round()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('1.2 L (Minimum)', style: TextStyle(fontSize: 11, color: ZalyxPalette.textMuted)),
                      Text('2.5 L (Standard)', style: TextStyle(fontSize: 11, color: ZalyxPalette.azureBlue)),
                      Text('4.5 L (Athlete)', style: TextStyle(fontSize: 11, color: ZalyxPalette.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Weight-Based Calculator Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ZalyxPalette.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ZalyxPalette.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BIOMETRIC PERSONALIZATION',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: ZalyxPalette.textMuted),
                  ),
                  const SizedBox(height: 14),

                  // Body Weight Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Body Weight', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${_weightKg.round()} kg (${(_weightKg * 2.20462).round()} lbs)',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: ZalyxPalette.deepOcean)),
                    ],
                  ),
                  Slider(
                    value: _weightKg,
                    min: 45,
                    max: 130,
                    divisions: 85,
                    activeColor: ZalyxPalette.freshCyan,
                    onChanged: (val) {
                      setState(() => _weightKg = val);
                      manager.setUserWeight(val);
                    },
                  ),
                  const SizedBox(height: 10),

                  // Activity Level Segmented
                  const Text('Daily Physical Activity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Sedentary', label: Text('Sedentary')),
                      ButtonSegment(value: 'Moderate', label: Text('Moderate')),
                      ButtonSegment(value: 'Intense', label: Text('Intense')),
                    ],
                    selected: {_activity},
                    onSelectionChanged: (set) {
                      setState(() => _activity = set.first);
                      manager.setActivityLevel(set.first);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Hot / Humid climate switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Warm / Tropical Climate', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Adds +450ml compensation for perspiration', style: TextStyle(fontSize: 12, color: ZalyxPalette.textMuted)),
                    value: _isHotClimate,
                    activeThumbColor: ZalyxPalette.azureBlue,
                    onChanged: (v) => setState(() => _isHotClimate = v),
                  ),
                  const Divider(height: 24),

                  // Recommendation Output
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Personalized Target', style: TextStyle(fontSize: 12, color: ZalyxPalette.textMuted)),
                          Text(
                            '$recommended ml / day',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ZalyxPalette.azureBlue),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ZalyxPalette.azureBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          manager.setDailyTarget(recommended);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Target updated to $recommended ml!')),
                          );
                        },
                        child: const Text('Apply Target'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ideal Drinking Schedule
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ZalyxPalette.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ZalyxPalette.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OPTIMAL HYDRATION PACING',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: ZalyxPalette.textMuted),
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleRow('07:30', 'Morning Awakening Glass', '350 ml'),
                  _buildScheduleRow('10:30', 'Mid-Morning Focus Refill', '450 ml'),
                  _buildScheduleRow('13:00', 'Pre-Lunch Digestion Cup', '300 ml'),
                  _buildScheduleRow('16:00', 'Afternoon Fatigue Buster', '500 ml'),
                  _buildScheduleRow('19:00', 'Evening Dinner Accompaniment', '400 ml'),
                  _buildScheduleRow('21:30', 'Light Night Rest Prep', '200 ml'),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleRow(String time, String event, String ml) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ZalyxPalette.iceBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(time, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(event, style: const TextStyle(fontSize: 13, color: ZalyxPalette.textPrimary))),
          Text(ml, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ZalyxPalette.azureBlue)),
        ],
      ),
    );
  }
}
