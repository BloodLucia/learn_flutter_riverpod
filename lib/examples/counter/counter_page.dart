import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((_) => 0);

class Counter extends ConsumerWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("rebuild.....");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Example with Riverpod"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${ref.watch(counterProvider)}",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).state++,
                child: const Text("Click me!"))
          ],
        ),
      ),
    );
  }
}
