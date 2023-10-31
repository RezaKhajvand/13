import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/timer_bloc/timer_bloc.dart';
import 'package:vpn/utils/timermanager.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({
    super.key,
  });

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> with WidgetsBindingObserver {
  Timer? timer;
  DateTime now = DateTime.now();
  late DateTime lastdatetime;
  Duration duration = Duration.zero;
  @override
  void initState() {
    super.initState();
    if (TimerManager.readTimer() != null) {
      List<String>? sharedtime = TimerManager.readTimer()!;
      lastdatetime = DateTime(
        int.parse(sharedtime[0]),
        int.parse(sharedtime[1]),
        int.parse(sharedtime[2]),
        int.parse(sharedtime[3]),
        int.parse(sharedtime[4]),
        int.parse(sharedtime[5]),
      );
      duration = now.difference(lastdatetime);
    } else {
      duration = Duration.zero;
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final seconds = duration.inSeconds + 1;

        duration = Duration(seconds: seconds);
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      duration = Duration.zero;
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secondes = twoDigits(duration.inSeconds.remainder(60));

    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerStarted) {
          startTimer();
        }
        if (state is TimerStoped) {
          stopTimer();
        }
      },
      child: Text(
        '$hours : $minutes : $secondes',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
