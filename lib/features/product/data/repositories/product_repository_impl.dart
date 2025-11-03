import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_product_repository.dart';

class ProductRepositoryImpl implements IProductRepository {
  // Mock data
  final List<ProductEntity> _products = [
    ProductEntity(id: '1', name: 'Laptop', price: 999.99),
    ProductEntity(id: '2', name: 'Mouse', price: 49.99),
    ProductEntity(id: '3', name: 'Keyboard', price: 89.99),
    ProductEntity(id: '4', name: 'Monitor', price: 249.99),
  ];

  @override
  Future<List<ProductEntity>> getProducts() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }
}
