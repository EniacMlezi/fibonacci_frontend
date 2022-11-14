class FibonacciRequest {
  final int id;
  final DateTime time;
  final int number;
  final String result;

  const FibonacciRequest(
      {required this.id,
      required this.time,
      required this.number,
      required this.result});

  factory FibonacciRequest.fromJson(Map<String, dynamic> json) {
    return FibonacciRequest(
        id: json['id'],
        time: DateTime.parse(json['time']),
        number: json['number'],
        result: json['result']);
  }
}
