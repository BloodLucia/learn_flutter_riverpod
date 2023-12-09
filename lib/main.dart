import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:learn_flutter_riverpod/examples/lifecycle/home.dart';
// import 'package:learn_flutter_riverpod/examples/counter/counter_page.dart';
// import 'package:learn_flutter_riverpod/examples/lifecycle/lifecycle_test.dart';
import 'package:learn_flutter_riverpod/examples/user_list/user_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const UserListPage(),
    );
  }
}
