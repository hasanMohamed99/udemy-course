import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/modules/counter_app/counter/cubit/cubit.dart';
import 'package:training_app/modules/counter_app/counter/cubit/states.dart';

// stateless contain one class provide widget

// stateful contain two classes
// 1. first class provide widget
// 2. second class provide state from this widget

class CounterScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit,CounterStates>(
        listener: (context,state) {
          if(state is CounterMinusState) print('Minus state ${state.counter}');
          if(state is CounterPlusState) print('Plus state ${state.counter}');
        },
        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'Counter',
                ),
              ),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: ()
                    {
                      CounterCubit.get(context).minus();
                    },
                    child: const Text(
                      'MINUS',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${CounterCubit.get(context).counter}',
                      style: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: ()
                    {
                      CounterCubit.get(context).plus();
                    },
                    child: const Text(
                      'PLUS',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
