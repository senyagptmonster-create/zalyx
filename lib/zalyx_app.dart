import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/zalyx_palette.dart';
import 'modules/goals/hydration_goals_view.dart';
import 'modules/quick_log/quick_log_view.dart';
import 'modules/ring_tracker/hydration_manager.dart';
import 'modules/ring_tracker/water_ring_view.dart';
import 'modules/weekly_chart/weekly_chart_view.dart';

class ZalyxWaterApp extends StatelessWidget {
  const ZalyxWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HydrationManager>(
      create: (_) => HydrationManager(),
      child: MaterialApp(
        title: 'Zalyx Hydration Flow',
        debugShowCheckedModeBanner: false,
        theme: ZalyxPalette.themeData(),
        home: const _ZalyxHomeShell(),
      ),
    );
  }
}

class _ZalyxHomeShell extends StatefulWidget {
  const _ZalyxHomeShell();

  @override
  State<_ZalyxHomeShell> createState() => _ZalyxHomeShellState();
}

class _ZalyxHomeShellState extends State<_ZalyxHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    WaterRingView(),
    QuickLogView(),
    WeeklyChartView(),
    HydrationGoalsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop_rounded),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Quick Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Goals',
          ),
        ],
      ),
    );
  }
}
