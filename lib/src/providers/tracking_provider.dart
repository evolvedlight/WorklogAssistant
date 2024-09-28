import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/enums/worklogstatus.dart';
import '../models/worklogentry.dart';
import 'jira_provider.dart';

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

  void stopTrackingAndAddWorklog() {
    final jira = ref.read(jiraNotifierProvider.notifier);
    stopTime();

    final currentIssue = state.currentIssue;
    final currentTime = state.secondsTimed;
    final startTime = DateTime.now().subtract(Duration(seconds: currentTime));

    jira.add(WorklogEntry(currentIssue, Duration(seconds: currentTime), startTime, WorklogStatus.pending));

    resetTime();
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

  void changeIssue(String key) {
    // it might already be tracking, in which case we should stop, send the update to the jira provider, and start again
    if (state.state == TrackingState.started) {
      stopTrackingAndAddWorklog();
    }
    resetTime();
    state = state.copyWith(currentIssue: key);

    startTime();
  }
}
