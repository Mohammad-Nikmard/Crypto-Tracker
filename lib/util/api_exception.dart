class APiException implements Exception {
  String message;
  int? errorCode;

  APiException(this.message, this.errorCode);
}
