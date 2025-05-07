import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase extends UseCase<Product, String> {
  final ProductRepository repository;
  ViewProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(params) {
    return repository.getProductById(params);
  }
}
