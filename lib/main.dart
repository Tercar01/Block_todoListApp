import 'dart:math';

import 'package:bloc_course/bloc/pizza_bloc.dart';
import 'package:bloc_course/pizza.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PizzaBloc()
            ..add(
              LoadPizzaCounter(),
            ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: false,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'The Pizza Bloc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<PizzaBloc, PizzaState>(
          builder: (context, state) {
            if (state is PizzaInitial) {
              return const CircularProgressIndicator();
            }
            if (state is PizzaLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.pizzas.length}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        for (int index = 0;
                            index < state.pizzas.length;
                            index++)
                          Positioned(
                            left: Random.secure().nextDouble(),
                            top: Random.secure().nextDouble(),
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: state.pizzas[index].image,
                            ),
                          )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<PizzaBloc>().add(
                    AddPizza(
                      pizza: Pizza.pizzas[0],
                    ),
                  );
            },
            child: const Icon(Icons.local_pizza_outlined),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            onPressed: () {
              context.read<PizzaBloc>().add(
                    RemovePizza(
                      pizza: Pizza.pizzas[0],
                    ),
                  );
            },
            child: const Icon(Icons.local_pizza_outlined),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            onPressed: () {
              context.read<PizzaBloc>().add(
                    AddPizza(
                      pizza: Pizza.pizzas[1],
                    ),
                  );
            },
            child: const Icon(Icons.local_pizza),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            onPressed: () {
              context.read<PizzaBloc>().add(
                    RemovePizza(
                      pizza: Pizza.pizzas[1],
                    ),
                  );
            },
            child: const Icon(Icons.local_pizza),
          ),
        ],
      ),
    );
  }
}
