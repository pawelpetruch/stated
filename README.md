# stated

final state

# example


```dart

/// ViewModel of Counter
class CounterState {
    CounterState({
        required this.counter,
        required this.increment,
    });

    final VoidCallback increment;
    final int counter;
}

/// Counter logic
class CounterBloc extends Bloc<CounterState> {
    int _counter = 0;

    @override 
    CounterState build() => CounterState(
        counter: _counter,
        increment: setState(() => _counter++),
    );
}

/// Counter presenter
class CounterWidget extends StatelessWidget {
    CounterWidget({this.state});
    final CounterState state;

    @override
    Widget build(BuildContext context) => 
        GestureDetecture(
            onTap: state.increment,
            child:  Text('Counter: ${state.counter}'),
        );
}

```