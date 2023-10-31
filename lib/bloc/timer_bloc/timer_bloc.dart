import 'package:bloc/bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial()) {
    on<StartTimer>((event, emit) {
      emit(TimerStarted());
    });
    on<StopTimer>((event, emit) {
      emit(TimerStoped());
    });
  }
}
