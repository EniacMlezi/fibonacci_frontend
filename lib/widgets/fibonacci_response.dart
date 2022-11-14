import 'package:flutter/material.dart';

/// Widget shows a Future Fibonacci result.
/// Shows progress indication when loading.
class FibonacciResponse extends StatelessWidget {
  const FibonacciResponse({super.key, required this.futureFibonacciResponse});

  final Future<String?>? futureFibonacciResponse;

  @override
  Widget build(BuildContext context) {
    if (futureFibonacciResponse == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder(
      future: futureFibonacciResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData
              ? Text('Answer: ${snapshot.data!}')
              : const Text('No response');
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
