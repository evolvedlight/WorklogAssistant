import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum for tracking current state (stopped, started)
enum TrackingState { stopped, started }

class TrackingProvider extends ChangeNotifier {
  String currentIssue = "";
  Timer? callbackTimer;
  int secondsTimed = 0;
  TrackingState state = TrackingState.stopped;

  void startTime() {
    secondsTimed = 0;
    state = TrackingState.started;
    if (callbackTimer != null && callbackTimer?.isActive == true) {
      callbackTimer?.cancel();
    }

    callbackTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondsTimed++;
      notifyListeners();
    });

    notifyListeners();
  }

  void stopTime() {
    state = TrackingState.stopped;
    callbackTimer?.cancel();
    notifyListeners();
  }

  void resetTime() {
    secondsTimed = 0;
    notifyListeners();
  }
}

final trackingProvider = ChangeNotifierProvider<TrackingProvider>((ref) {
  return TrackingProvider();
});
