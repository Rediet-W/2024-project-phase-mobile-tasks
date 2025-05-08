import 'package:equatable/equatable.dart';

/// Base class for all failures in the app.
abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}
