// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'counter_cubit.dart';

class CounterState {
  const CounterState({
    required this.counterValue,
    required this.wasIncremented,
  });

  final int counterValue;
  final bool wasIncremented;
}
