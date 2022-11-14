import 'package:flutter/material.dart';

/// Widget creates a Form for requesting a Fibonacci number. Calls [onRequest]
/// when a valid request is submitted.
class FibonacciRequestForm extends StatelessWidget {
  FibonacciRequestForm({super.key, this.onRequest});

  final Future<void> Function(int)? onRequest;

  final _formKey = GlobalKey<FormState>();

  void submit(String value) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    onRequest!(int.parse(value)); //Tell listeners a valid request submits.
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController numberController = TextEditingController();
    return SizedBox(
      width: 150,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction, //Validate edit.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fibonacci:'),
            TextFormField(
              autofocus: true,
              controller: numberController,
              decoration: const InputDecoration(errorMaxLines: 2),
              textAlign: TextAlign.right,
              validator: ((value) {
                //Validates the entered number.
                int? intValue;
                if (value == null ||
                    (intValue = int.tryParse(value)) == null ||
                    intValue! < 0 ||
                    intValue > 10000) {
                  return 'Please enter a valid integer between 0 and 10000';
                }
                return null;
              }),
              onFieldSubmitted: (value) => submit(value),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: () => submit(numberController.text),
                child: const Text('GO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
