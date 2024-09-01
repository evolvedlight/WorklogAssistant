import 'dart:async';

import 'package:flutter/foundation.dart';

// enum for tracking current state (stopped, started)
enum TrackingState { stopped, started }

class TrackingModel extends ChangeNotifier {
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
      print("Timer callback");
      secondsTimed++;
      // notify the UI to change
      notifyListeners();
    });

    notifyListeners();
  }

  void stopTime() {
    state = TrackingState.stopped;
    callbackTimer?.cancel();
    notifyListeners();
  }
}