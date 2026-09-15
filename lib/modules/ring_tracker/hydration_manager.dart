import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkLog {
  final String id;
  final DateTime timestamp;
  final int amountMl;
  final String beverageType;

  DrinkLog({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    required this.beverageType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'amountMl': amountMl,
        'beverageType': beverageType,
      };

  factory DrinkLog.fromJson(Map<String, dynamic> json) => DrinkLog(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        amountMl: json['amountMl'] as int,
        beverageType: json['beverageType'] as String,
      );
}

class DailyHydrationRecord {
  final String dayName; // Mon, Tue, etc.
  final int totalMl;
  final int targetMl;

  DailyHydrationRecord({
    required this.dayName,
    required this.totalMl,
    required this.targetMl,
  });

  Map<String, dynamic> toJson() => {
        'dayName': dayName,
        'totalMl': totalMl,
        'targetMl': targetMl,
      };

  factory DailyHydrationRecord.fromJson(Map<String, dynamic> json) => DailyHydrationRecord(
        dayName: json['dayName'] as String,
        totalMl: json['totalMl'] as int,
        targetMl: json['targetMl'] as int,
      );
}

class HydrationManager extends ChangeNotifier {
  static const String _keyDailyTarget = 'zalyx_daily_target_ml';
  static const String _keyUserWeight = 'zalyx_user_weight_kg';
  static const String _keyActivity = 'zalyx_activity_level';
  static const String _keyDrinkLogs = 'zalyx_drink_logs';
  static const String _keyWeeklyData = 'zalyx_weekly_history';

  int _dailyTargetMl = 2500;
  double _userWeightKg = 70.0;
  String _activityLevel = 'Moderate'; // Sedentary, Moderate, Intense
  List<DrinkLog> _todayLogs = [];
  List<DailyHydrationRecord> _weeklyRecords = [];

  HydrationManager() {
    _loadState();
  }

  int get dailyTargetMl => _dailyTargetMl;
  double get userWeightKg => _userWeightKg;
  String get activityLevel => _activityLevel;
  List<DrinkLog> get todayLogs => List.unmodifiable(_todayLogs);
  List<DailyHydrationRecord> get weeklyRecords => List.unmodifiable(_weeklyRecords);

  int get todayTotalMl => _todayLogs.fold(0, (sum, item) => sum + item.amountMl);

  double get progressRatio {
    if (_dailyTargetMl <= 0) return 0.0;
    return (todayTotalMl / _dailyTargetMl).clamp(0.0, 1.5);
  }

  int get remainingMl {
    final diff = _dailyTargetMl - todayTotalMl;
    return diff > 0 ? diff : 0;
  }

  int get recommendedTargetMl {
    final base = (_userWeightKg * 35).round();
    int bonus = 0;
    if (_activityLevel == 'Moderate') bonus = 400;
    if (_activityLevel == 'Intense') bonus = 800;
    return base + bonus;
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _dailyTargetMl = prefs.getInt(_keyDailyTarget) ?? 2500;
      _userWeightKg = prefs.getDouble(_keyUserWeight) ?? 70.0;
      _activityLevel = prefs.getString(_keyActivity) ?? 'Moderate';

      final rawLogs = prefs.getStringList(_keyDrinkLogs);
      if (rawLogs != null && rawLogs.isNotEmpty) {
        _todayLogs = rawLogs
            .map((str) => DrinkLog.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } else {
        // Initial sample drinks
        final now = DateTime.now();
        _todayLogs = [
          DrinkLog(
            id: 'init-1',
            timestamp: now.subtract(const Duration(hours: 4)),
            amountMl: 350,
            beverageType: 'Morning Water',
          ),
          DrinkLog(
            id: 'init-2',
            timestamp: now.subtract(const Duration(hours: 2)),
            amountMl: 500,
            beverageType: 'Electrolyte Splash',
          ),
          DrinkLog(
            id: 'init-3',
            timestamp: now.subtract(const Duration(minutes: 30)),
            amountMl: 250,
            beverageType: 'Green Tea',
          ),
        ];
      }

      final rawWeekly = prefs.getStringList(_keyWeeklyData);
      if (rawWeekly != null && rawWeekly.isNotEmpty) {
        _weeklyRecords = rawWeekly
            .map((str) => DailyHydrationRecord.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } else {
        _weeklyRecords = [
          DailyHydrationRecord(dayName: 'Mon', totalMl: 2400, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Tue', totalMl: 2650, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Wed', totalMl: 2200, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Thu', totalMl: 2800, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Fri', totalMl: 2500, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Sat', totalMl: 2900, targetMl: 2500),
          DailyHydrationRecord(dayName: 'Sun', totalMl: 1100, targetMl: 2500),
        ];
      }
    } catch (e) {
      debugPrint('Error loading hydration state: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> addDrink(int ml, {String type = 'Pure Water'}) async {
    final log = DrinkLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      amountMl: ml,
      beverageType: type,
    );
    _todayLogs.insert(0, log);
    notifyListeners();
    await _persistLogs();
  }

  Future<void> removeLog(String id) async {
    _todayLogs.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persistLogs();
  }

  Future<void> setDailyTarget(int ml) async {
    _dailyTargetMl = ml.clamp(1000, 5000);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailyTarget, _dailyTargetMl);
  }

  Future<void> setUserWeight(double kg) async {
    _userWeightKg = kg.clamp(40.0, 160.0);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyUserWeight, _userWeightKg);
  }

  Future<void> setActivityLevel(String level) async {
    _activityLevel = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActivity, _activityLevel);
  }

  Future<void> _persistLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _todayLogs.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_keyDrinkLogs, encoded);
  }
}
