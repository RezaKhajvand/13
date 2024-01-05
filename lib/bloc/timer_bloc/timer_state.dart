part of 'timer_bloc.dart';

abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerStarted extends TimerState {}

class TimerStoped extends TimerState {}
