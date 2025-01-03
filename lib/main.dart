import 'package:english_test/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
   const MyApp(),
   
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English_test',
      theme: ThemeData(
      
     textTheme: TextTheme( 
      
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
        ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.black),
          ),
        ),
      elevatedButtonTheme:  ElevatedButtonThemeData( style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.black),
          ),
        ),

        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
