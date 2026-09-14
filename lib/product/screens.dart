import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../app/brand.dart';

class ZalyxHomeScreen extends StatefulWidget {
  const ZalyxHomeScreen({super.key});
  @override
  State<ZalyxHomeScreen> createState() => _ZalyxHomeScreenState();
}

class _ZalyxHomeScreenState extends State<ZalyxHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WaterRingTrackerScreen(),
    const QuickLogScreen(),
    const WeeklyChartScreen(),
    const HydrationGoalsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zalyx', style: AppTheme.display(cSurface)),
        backgroundColor: cAccent,
      ),
      drawer: Drawer(
        backgroundColor: cBg,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: cAccent),
              child: Text('Zalyx Hydration', style: AppTheme.display(cSurface)),
            ),
            ListTile(
              title: Text('Water Ring Tracker', style: AppTheme.text(cInk)),
              onTap: () {
                setState(() { _currentIndex = 0; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Quick Log', style: AppTheme.text(cInk)),
              onTap: () {
                setState(() { _currentIndex = 1; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Weekly Chart', style: AppTheme.text(cInk)),
              onTap: () {
                setState(() { _currentIndex = 2; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Hydration Goals', style: AppTheme.text(cInk)),
              onTap: () {
                setState(() { _currentIndex = 3; });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}

class WaterRingTrackerScreen extends StatelessWidget {
  const WaterRingTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Water Ring Tracker', style: AppTheme.display(cInk)),
          const SizedBox(height: 20),
          Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cAccent, width: 8),
            ),
            child: Center(child: Text('64 oz', style: AppTheme.display(cAccent2))),
          ),
        ],
      ),
    );
  }
}

class QuickLogScreen extends StatelessWidget {
  const QuickLogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Quick Log', style: AppTheme.display(cInk)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text('+ 8 oz', style: AppTheme.text(cSurface))),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: Text('+ 16 oz', style: AppTheme.text(cSurface))),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: Text('+ 24 oz', style: AppTheme.text(cSurface))),
        ],
      ),
    );
  }
}

class WeeklyChartScreen extends StatelessWidget {
  const WeeklyChartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Weekly Chart', style: AppTheme.display(cInk)),
    );
  }
}

class HydrationGoalsScreen extends StatelessWidget {
  const HydrationGoalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hydration Goals', style: AppTheme.display(cInk)),
    );
  }
}
