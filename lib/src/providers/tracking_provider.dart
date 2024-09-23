import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tracking_provider.g.dart';

// enum for tracking current state (stopped, started)
enum TrackingState { stopped, started }

class TrackingStateData {
  final String currentIssue;
  final int secondsTimed;
  final TrackingState state;

  TrackingStateData({
    required this.currentIssue,
    required this.secondsTimed,
    required this.state,
  });

  TrackingStateData copyWith({
    String? currentIssue,
    int? secondsTimed,
    TrackingState? state,
  }) {
    return TrackingStateData(
      currentIssue: currentIssue ?? this.currentIssue,
      secondsTimed: secondsTimed ?? this.secondsTimed,
      state: state ?? this.state,
    );
  }
}

@riverpod
class TrackingNotifier extends _$TrackingNotifier {
  Timer? _callbackTimer;

  @override
  TrackingStateData build() {
    return TrackingStateData(
      currentIssue: "",
      secondsTimed: 0,
      state: TrackingState.stopped,
    );
  }

  void startTime() {
    state = state.copyWith(secondsTimed: 0, state: TrackingState.started);
    _callbackTimer?.cancel();

    _callbackTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      state = state.copyWith(secondsTimed: state.secondsTimed + 1);
    });
  }

  void stopTime() {
    state = state.copyWith(state: TrackingState.stopped);
    _callbackTimer?.cancel();
  }

  void resetTime() {
    state = state.copyWith(secondsTimed: 0);
  }

  void startWithIssue(String key) {
    state = state.copyWith(currentIssue: key);
  }
}
