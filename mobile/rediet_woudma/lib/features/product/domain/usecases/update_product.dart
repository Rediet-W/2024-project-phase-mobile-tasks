import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase extends UseCase<void, Product> {
  final ProductRepository repository;
  UpdateProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.updateProduct(params);
  }
}
