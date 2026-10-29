import 'package:flutter/material.dart';

class LogObserver extends NavigatorObserver {
  final List<String> logs = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final msg = 'PUSH    → ${route.settings.name} (dari ${previousRoute?.settings.name})';
    logs.add(msg);
    debugPrint(msg);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final msg = 'POP     ← ${route.settings.name} (kembali ke ${previousRoute?.settings.name})';
    logs.add(msg);
    debugPrint(msg);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final msg = 'REPLACE ${oldRoute?.settings.name} → ${newRoute?.settings.name}';
    logs.add(msg);
    debugPrint(msg);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final msg = 'REMOVE  ${route.settings.name}';
    logs.add(msg);
    debugPrint(msg);
  }
}
