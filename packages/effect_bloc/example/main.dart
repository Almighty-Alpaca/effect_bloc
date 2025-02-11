import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:effect_bloc/effect_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- bloc: ${bloc.runtimeType}');
  }
}

void main() {
  BlocOverrides.runZoned(
    () {
      cubitMain();
      blocMain();
    },
    blocObserver: SimpleBlocObserver(),
  );
}

void cubitMain() {
  print('----------CUBIT----------');

  /// Create a `CounterCubit` instance.
  final cubit = CounterCubit(count: 10);

  /// Access the state of the `cubit` via `state`.
  print(cubit.state); // 0

  /// Interact with the `cubit` to trigger `state` changes.
  cubit.increment();

  /// Access the new `state`.
  print(cubit.state); // 1

  /// Close the `cubit` when it is no longer needed.
  cubit.close();
}

void blocMain() async {
  print('----------BLOC----------');

  /// Create a `CounterBloc` instance.
  final bloc = CounterBloc();

  /// Access the state of the `bloc` via `state`.
  print(bloc.state);

  /// Interact with the `bloc` to trigger `state` changes.
  bloc.add(CounterEventIncrement());

  /// Wait for next iteration of the event-loop
  /// to ensure event has been processed.
  await Future<void>.delayed(Duration.zero);

  /// Access the new `state`.
  print(bloc.state);

  /// Close the `bloc` when it is no longer needed.
  await bloc.close();
}

/// Counter Effect
enum CounterEffect { started, completed }

/// A `CounterCubit` which manages an `int` as its state.
class CounterCubit extends Cubit<int> with BlocEffect<int, CounterEffect> {
  final int count;

  /// The initial state of the `CounterCubit` is 0.
  CounterCubit({required this.count}) : super(0);

  /// When increment is called, the current state
  /// of the cubit is accessed via `state` and
  /// a new `state` is emitted via `emit`.
  void increment() {
    if (state == 0) {
      emitEffect(CounterEffect.started);
    }

    if (state < count - 1) {
      emit(state + 1);
    } else {
      emitEffect(CounterEffect.completed);
    }
  }
}

/// The events which `CounterBloc` will react to.
abstract class CounterEvent {
  const CounterEvent();
}

class CounterEventIncrement extends CounterEvent {
  const CounterEventIncrement();
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class CounterBloc extends Bloc<CounterEvent, int> {
  /// The initial state of the `CounterBloc` is 0.
  CounterBloc() : super(0) {
    on<CounterEventIncrement>(_onIncrement);
  }

  void _onIncrement(
    CounterEventIncrement event,
    Emitter<int> emit,
  ) {
    emit(state + 1);
  }
}
