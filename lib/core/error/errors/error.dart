class GeneralError implements Exception {
  final String message; // user
  final StackTrace? stackTrace; // developer

  const GeneralError(this.message, [this.stackTrace]);
  @override
  String toString() {
    // TODO: implement toString
    return message.toString();
  }
}
