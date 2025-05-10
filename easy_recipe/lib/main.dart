import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)), home: const MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Column(
        children: [
          Text('welcome to easyRecipes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('a recipe app for everyone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          SizedBox(height: 20),
          Text('search for your favorite recipes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          SizedBox(height: 20),
          Text('get started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}
