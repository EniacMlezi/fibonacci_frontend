import 'package:fibonacci_frontend/services/fibonacci_service.dart';
import 'package:flutter/material.dart';

import 'widgets/fibonacci_request_history.dart';
import 'widgets/fibonacci_request_form.dart';
import 'widgets/fibonacci_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibonacci',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FibonacciHome(
        fibonacciService: ApiFibonacciService(),
      ),
    );
  }
}

class FibonacciHome extends StatefulWidget {
  const FibonacciHome({super.key, required this.fibonacciService});

  final FibonacciService fibonacciService;

  @override
  State<FibonacciHome> createState() => _FibonacciHomeState();
}

class _FibonacciHomeState extends State<FibonacciHome> {
  Future<String?>? futureFibonacci;
  DateTime _historyStartDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                FibonacciRequestForm(
                  onRequest: (n) async {
                    setState(() {
                      //Place request, let response widget handle response.
                      futureFibonacci = widget.fibonacciService.getFibonacci(n);
                    });
                    //After request completes, update history widget.
                    futureFibonacci!.whenComplete(() =>
                        setState(() => _historyStartDateTime = DateTime.now()));
                  },
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      FibonacciResponse(
                          futureFibonacciResponse: futureFibonacci),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 2, color: Colors.grey),
            Expanded(
              child: FibonacciRequestHistory(
                fibonacciService: widget.fibonacciService,
                historyStartDateTime: _historyStartDateTime,
                pageSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
