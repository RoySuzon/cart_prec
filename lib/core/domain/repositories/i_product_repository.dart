import '../entities/product_entity.dart';

abstract class IProductRepository {
  /// Fetches a list of available products.
  Future<List<ProductEntity>> getProducts();
}