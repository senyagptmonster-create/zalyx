import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/zalyx_palette.dart';
import '../ring_tracker/hydration_manager.dart';

class QuickLogView extends StatefulWidget {
  const QuickLogView({super.key});

  @override
  State<QuickLogView> createState() => _QuickLogViewState();
}

class _QuickLogViewState extends State<QuickLogView> {
  String _selectedBeverage = 'Pure Water';
  double _customAmount = 350;

  final List<Map<String, dynamic>> _quickButtons = [
    {
      'label': 'Small Glass',
      'ml': 250,
      'icon': Icons.local_cafe_rounded,
      'desc': 'Standard teacup or glass',
    },
    {
      'label': 'Water Bottle',
      'ml': 500,
      'icon': Icons.sports_bar_rounded,
      'desc': 'Half liter sport bottle',
    },
    {
      'label': 'Fitness Tumbler',
      'ml': 750,
      'icon': Icons.fitness_center_rounded,
      'desc': 'Hydration workout shaker',
    },
    {
      'label': 'Full Carafe',
      'ml': 1000,
      'icon': Icons.water_damage_rounded,
      'desc': '1.0L daily desktop carafe',
    },
  ];

  final List<String> _beverages = [
    'Pure Water',
    'Electrolytes',
    'Green Tea',
    'Sparkling Mineral',
    'Coconut Water',
  ];

  void _logAmount(BuildContext context, int ml) {
    final manager = context.read<HydrationManager>();
    manager.addDrink(ml, type: _selectedBeverage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ZalyxPalette.azureBlue,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('Logged +$ml ml of $_selectedBeverage!'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.add_circle_outline_rounded, color: ZalyxPalette.azureBlue),
            SizedBox(width: 8),
            Text('Quick Hydration Log'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beverage Type Selector
            const Text(
              'SELECT BEVERAGE TYPE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: ZalyxPalette.textMuted),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _beverages.map((bev) {
                  final isSelected = _selectedBeverage == bev;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(bev),
                      selected: isSelected,
                      selectedColor: ZalyxPalette.azureBlue,
                      backgroundColor: ZalyxPalette.cardSurface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : ZalyxPalette.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected ? ZalyxPalette.azureBlue : ZalyxPalette.borderLight,
                      ),
                      onSelected: (_) => setState(() => _selectedBeverage = bev),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Tap +250ml, +500ml, +750ml quick add buttons
            const Text(
              'ONE-TAP LOGGING PRESETS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: ZalyxPalette.textMuted),
            ),
            const SizedBox(height: 10),

            ..._quickButtons.map((btn) {
              final ml = btn['ml'] as int;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: ZalyxPalette.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ZalyxPalette.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: ZalyxPalette.azureBlue.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _logAmount(context, ml),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ZalyxPalette.iceBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(btn['icon'] as IconData, color: ZalyxPalette.azureBlue, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  btn['label'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ZalyxPalette.deepOcean),
                                ),
                                Text(
                                  btn['desc'] as String,
                                  style: const TextStyle(fontSize: 12, color: ZalyxPalette.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ZalyxPalette.azureBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+$ml ml',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Custom Slider Entry Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ZalyxPalette.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ZalyxPalette.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Custom Serving Size',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ZalyxPalette.deepOcean),
                      ),
                      Text(
                        '${_customAmount.round()} ml',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: ZalyxPalette.azureBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _customAmount,
                    min: 100,
                    max: 1200,
                    divisions: 22,
                    activeColor: ZalyxPalette.azureBlue,
                    onChanged: (v) => setState(() => _customAmount = v),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ZalyxPalette.azureBlue,
                        side: const BorderSide(color: ZalyxPalette.azureBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _logAmount(context, _customAmount.round()),
                      icon: const Icon(Icons.add),
                      label: Text('LOG +${_customAmount.round()} ML CUSTOM'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
