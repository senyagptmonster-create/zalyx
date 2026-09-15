import 'package:flutter/material.dart';
import '../theme/zalyx_theme.dart';
import '../painters/hydration_ring_painter.dart';

class HydrationStudioScreen extends StatefulWidget {
  const HydrationStudioScreen({super.key});

  @override
  State<HydrationStudioScreen> createState() => _HydrationStudioScreenState();
}

class _HydrationStudioScreenState extends State<HydrationStudioScreen>
    with SingleTickerProviderStateMixin {
  int _currentMl = 1500;
  int _targetMl = 2500;
  final List<String> _intakeLog = ['08:30 AM • 350 ml', '10:15 AM • 500 ml', '01:00 PM • 650 ml'];
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _addWater(int amountMl) {
    setState(() {
      _currentMl += amountMl;
      final now = TimeOfDay.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _intakeLog.insert(0, '$timeStr • $amountMl ml');
    });
  }

  void _resetIntake() {
    setState(() {
      _currentMl = 0;
      _intakeLog.clear();
    });
  }

  void _showTargetSheet() {
    int tempTarget = _targetMl;
    showModalBottomSheet(
      context: context,
      backgroundColor: ZalyxTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily Hydration Target', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Target Quota: $tempTarget ml (${(tempTarget * 0.033814).toStringAsFixed(1)} fl oz)'),
              Slider(
                value: tempTarget.toDouble(),
                min: 1500,
                max: 4000,
                divisions: 25,
                activeColor: ZalyxTheme.accent,
                onChanged: (v) => setSheetState(() => tempTarget = v.round()),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZalyxTheme.accent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() => _targetMl = tempTarget);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save Target'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ZalyxTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Hydration Log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_intakeLog.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No water logged yet today. Drink up!', style: TextStyle(color: ZalyxTheme.muted)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: _intakeLog.length,
                itemBuilder: (ctx, idx) => ListTile(
                  leading: const Icon(Icons.water_drop, color: ZalyxTheme.accentLight),
                  title: Text(_intakeLog[idx], style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentMl / _targetMl).clamp(0.0, 1.5);
    final flOz = (_currentMl * 0.033814).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZALYX HYDRATION', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistorySheet,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showTargetSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Daily Progress Text
              Text(
                '${(progress * 100).round()}% Completed',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ZalyxTheme.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$flOz fl oz consumed today',
                style: const TextStyle(color: ZalyxTheme.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // Animated Hydration Ring
              Center(
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: HydrationRingPainter(
                        progress: progress,
                        wavePhase: _waveController.value * 2 * 3.14159,
                      ),
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop_outlined, color: ZalyxTheme.accent, size: 36),
                            const SizedBox(height: 6),
                            Text(
                              '$_currentMl',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: ZalyxTheme.ink,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              '/ $_targetMl ML',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ZalyxTheme.muted,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            // Quick Intake Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Intake Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _quickButton('+200 ml', 'Glass', 200),
                      _quickButton('+330 ml', 'Can', 330),
                      _quickButton('+500 ml', 'Bottle', 500),
                      _quickButton('+750 ml', 'Jug', 750),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Reset Button
            TextButton.icon(
              onPressed: _resetIntake,
              icon: const Icon(Icons.refresh, size: 16, color: ZalyxTheme.muted),
              label: const Text('Reset Daily Log', style: TextStyle(color: ZalyxTheme.muted, fontSize: 13)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

  Widget _quickButton(String label, String sub, int amount) {
    return InkWell(
      onTap: () => _addWater(amount),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ZalyxTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ZalyxTheme.edge),
        ),
        child: Column(
          children: [
            const Icon(Icons.add_circle, color: ZalyxTheme.accent, size: 20),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub, style: const TextStyle(color: ZalyxTheme.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
