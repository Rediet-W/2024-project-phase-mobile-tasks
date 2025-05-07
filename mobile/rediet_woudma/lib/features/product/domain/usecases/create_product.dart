import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase extends UseCase<void, Product> {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Product params) {
    return repository.createProduct(params);
  }
}
