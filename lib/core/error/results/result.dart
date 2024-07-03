import 'package:blog_app/core/error/errors/error.dart';

class Result<T> {
  final T? _data;
  final GeneralError? error;

  const Result({
    T? data,
    this.error,
  }) : _data = data;

  bool get hasError => error != null;
  T get data => _data!;

  @override
  String toString() {
    if (error != null) return error!.message.toString();
    return data.toString();
  }
}
