import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_recipe/core/data/repositories/recipe_repository_impl.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_cubit.dart';
import 'package:easy_recipe/core/presentation/screens/home_screen.dart';
import 'package:easy_recipe/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Recipe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => RecipeCubit(
          RecipeRepositoryImpl(FirebaseFirestore.instance),
        ),
        child: const HomeScreen(),
      ),
    );
  }
}
