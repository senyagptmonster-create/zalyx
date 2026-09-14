import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZalyxStore extends ChangeNotifier {
  int _currentOz = 0;
  int get currentOz => _currentOz;

  Future<void> addOz(int oz) async {
    _currentOz += oz;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('zalyx_currentOz', _currentOz);
    notifyListeners();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _currentOz = prefs.getInt('zalyx_currentOz') ?? 0;
    notifyListeners();
  }
}
