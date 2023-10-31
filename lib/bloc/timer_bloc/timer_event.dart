part of 'timer_bloc.dart';


abstract class TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}
