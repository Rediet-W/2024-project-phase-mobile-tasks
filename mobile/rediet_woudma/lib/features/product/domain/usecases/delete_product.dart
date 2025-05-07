import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase extends UseCase<void, String> {
  final ProductRepository repository;
  DeleteProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.deleteProduct(params);
  }
}
