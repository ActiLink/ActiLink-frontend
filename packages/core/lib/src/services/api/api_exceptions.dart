part of 'package:core/src/services/api/api_service.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class InternalServerException extends ApiException {
  InternalServerException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class ConflictException extends ApiException {
  ConflictException(super.message);
}
