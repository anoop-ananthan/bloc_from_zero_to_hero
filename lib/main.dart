import 'package:bloc_zero_to_hero/second_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'counter/cubit/counter_cubit.dart';
import 'internet/cubit/internet_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

  Connectivity connectivity = Connectivity();

  Bloc.observer = AppBlocObserver();

  runApp(MyApp(connectivity: connectivity));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.connectivity,
  });

  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CounterCubit(),
          ),
          BlocProvider(
            create: (context) => InternetCubit(connectivity: connectivity),
          ),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('onEvent\n$bloc\n$event\n');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('onChange\n$bloc\n$change\n');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('onTransition\n$bloc\n$transition\n');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate\n$bloc\n');
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zero to Hero'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<InternetCubit, InternetState>(
              listener: (context, state) {
                if (_isWifyConnected(state)) {
                  context.read<CounterCubit>().increment();
                }
                if (_isMobileConnected(state)) {
                  context.read<CounterCubit>().decrement();
                }
              },
              builder: (context, state) {
                if (_isWifyConnected(state)) {
                  return const InternetText('Wi-fi', color: Colors.green);
                } else if (_isMobileConnected(state)) {
                  return const InternetText('Mobile', color: Colors.red);
                } else if (_isDisconneected(state)) {
                  return const InternetText('Disconnected', color: Colors.grey);
                } else {
                  return Text('Unknown state $state');
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocConsumer<CounterCubit, CounterState>(
              listenWhen: (previous, current) => previous.wasIncremented != current.wasIncremented,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.wasIncremented ? 'Incremented' : 'Decremented'),
                      duration: const Duration(milliseconds: 600),
                    ),
                  );
              },
              builder: (context, state) {
                if (state.counterValue < 0) {
                  return Text(
                    'BRR, Negative ${state.counterValue}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else if (state.counterValue % 2 == 0) {
                  return Text(
                    'Yaay  ${state.counterValue}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else if (state.counterValue == 5) {
                  return Text(
                    'hmm 5',
                    style: Theme.of(context).textTheme.headlineLarge,
                  );
                } else {
                  return Text(
                    state.counterValue.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => context.read<CounterCubit>().increment(),
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => context.read<CounterCubit>().decrement(),
                  tooltip: 'Increment',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<CounterCubit>(),
                      child: const SecondPage(),
                    ),
                  ),
                );
              },
              child: const Text(
                "Go to second screen",
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDisconneected(InternetState state) => state is InternetDisconnected;

  bool _isMobileConnected(InternetState state) {
    return state is InternetConnected && state.connectionType == ConnectionType.mobile;
  }

  bool _isWifyConnected(InternetState state) =>
      state is InternetConnected && state.connectionType == ConnectionType.wifi;
}

class InternetText extends StatelessWidget {
  const InternetText(
    this.text, {
    super.key,
    this.color = Colors.black,
  });

  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color),
    );
  }
}
