import 'package:dartz/dartz.dart';
import '../error/failure.dart';

/// Every UseCase will return an Either<Failure, T> and accept Params.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
