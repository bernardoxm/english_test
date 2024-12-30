import 'package:flutter/material.dart';

class ErrorLoad extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorLoad({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         SizedBox( height: 250, child: Image.asset('assets/Images/wordsapperror.png'),),
         Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text("Something went wrong, let's try again"), TextButton(
            onPressed: onRetry,
            child: const Text('click here?'),
          ),
           ],
         ),
         
        ],
      ),
    );
  }
}
