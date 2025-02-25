import 'package:english_test/controller/error_internet.dart';
import 'package:flutter/material.dart';


class ErrorLoad extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorLoad({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset('assets/Images/wordsapperror.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                NetworkController.checkConnectionAndRetry(
                  context: context,
                  onRetry: onRetry,
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
