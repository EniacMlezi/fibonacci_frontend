# fibonacci_frontend

This project gives a front-end for the [Fibonacci API](https://github.com/EniacMlezi/FibonacciApi). The front-end is written in flutter to support almost all platforms (android, ios, windows, linux, macos and web!) out of the box.

A live demo of the front-end can be found at: [Demo](https://fibonacciapi20221114115416.azurewebsites.net/#/).



## overview
The front-end is split up in multiple widgets (creating a request, displaying a response, displaying request history). 

The FibonacciRequest widget is used to create a form for inputting and validate a request.

When a request is made, the FibonacciResponse widget uses the Future result of said request to either draw a progress indicator, a result or an error.

FibonacciRequestHistory is loaded using pagination and an infinitely scrolling list. Pagination is used so not all History has to be retrieved at once.

When a widget needs to access the API, requests are made through a Service, the FibonacciService. The FibonacciService is injected into the FibonacciHome widget (DI/IoC). The one implementer for the FibonacciService is the ApiFibonacciService. This implementation uses simple HTTP requests to access the API and deserializes the (JSON) responses to objects.
