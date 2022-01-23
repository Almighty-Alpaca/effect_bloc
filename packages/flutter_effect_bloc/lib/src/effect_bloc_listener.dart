import 'dart:async';

import 'package:effect_bloc/effect_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef EffectBlocWidgetListener<E> = void Function(
    BuildContext context, E effect);

///
/// EffectBlocListener
///
class EffectBlocListener<E extends EffectBlocBase<T>, T>
    extends StatefulWidget {
  final EffectBlocWidgetListener<T> effectListener;
  final E? effect;
  final Widget child;

  const EffectBlocListener({
    Key? key,
    required this.child,
    this.effect,
    required this.effectListener,
  }) : super(key: key);

  @override
  State<EffectBlocListener<E, T>> createState() =>
      _EffectBlocListenerState<E, T>();
}

class _EffectBlocListenerState<E extends EffectBlocBase<T>, T>
    extends State<EffectBlocListener<E, T>> {
  StreamSubscription<T>? _subscription;
  late E _effect;

  @override
  void initState() {
    super.initState();
    _effect = widget.effect ?? context.read<E>();
    _subscribe();
  }

  @override
  void didUpdateWidget(EffectBlocListener<E, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldEffect = oldWidget.effect;
    final currentEffect = widget.effect ?? context.read<E>();
    if (oldEffect != currentEffect) {
      _effect = currentEffect;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _subscribe() {
    _subscription = _effect.effectStream.listen((state) {
      widget.effectListener(context, state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
