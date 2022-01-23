import 'package:effect_bloc/effect_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_effect_bloc/src/effect_bloc_listener.dart';

typedef EffectBlocWidgetBuilder<S> = Widget Function(
    BuildContext context, S state);

///
/// EffectBlocConsumer
///
class EffectBlocConsumer<B extends BlocEffect<S, E>, S, E>
    extends StatelessWidget {
  final BlocWidgetBuilder<S> builder;
  final EffectBlocWidgetListener<E> effectListener;
  final BlocBuilderCondition<S>? buildWhen;
  final B? bloc;

  const EffectBlocConsumer({
    Key? key,
    required this.builder,
    required this.effectListener,
    this.bloc,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final effect = bloc as EffectBlocBase<E>;

    return EffectBlocListener<EffectBlocBase<E>, E>(
        child: BlocBuilder<B, S>(
          builder: builder,
          buildWhen: buildWhen,
          bloc: bloc,
        ),
        effect: bloc,
        effectListener: effectListener);
  }
}
