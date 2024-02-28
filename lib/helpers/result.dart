class Result<T> {
  Result({
    this.valid = true,
    this.hasData = true,
    this.errors,
    this.error,
    this.message,
    this.data,
  });

  bool valid = true;
  bool hasData = true;
  List<String>? errors;
  String? error;
  String? message;
  T? data;

  bool isSuccess() {
    return valid;
  }

  bool isError() {
    return error != null;
  }

  bool hasResults() {
    return data != null;
  }

  List<String> getErrors() {
    return errors ?? <String>[];
  }

  String? getError() {
    return error;
  }

  T? getData() {
    return data;
  }

  factory Result.ok({required bool value}) => Result(valid: value);
  factory Result.fail({required String error}) => Result(error: error);
  factory Result.fails({required List<String> errors}) =>
      Result(errors: errors);
}
