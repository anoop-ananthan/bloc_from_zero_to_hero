import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_zero_to_hero/counter/cubit/counter_cubit.dart';
import 'package:test/test.dart';

void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test('Initial test', () {
      expect(
        counterCubit.state,
        const CounterState(counterValue: 0, wasIncremented: false),
      );
    });

    blocTest<CounterCubit, CounterState>(
      'emits [CounterState] when increment is added.',
      build: () => counterCubit,
      act: (cubit) => cubit.increment(),
      expect: () => const <CounterState>[CounterState(counterValue: 1, wasIncremented: true)],
    );

    blocTest<CounterCubit, CounterState>(
      'emits [CounterState] when decrement is added.',
      build: () => counterCubit,
      act: (cubit) => cubit.decrement(),
      expect: () => const <CounterState>[CounterState(counterValue: -1, wasIncremented: false)],
    );
  });
}
