import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_cart_repository.dart';
import 'package:cart_prec/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartRepositoryImpl implements ICartRepository {
  CartRepositoryImpl({required this.localDataSource});
  final CartLocalDataSource localDataSource;

  @override
  Future<void> addProductToCart(ProductEntity product) async {
    final existingItem = localDataSource.getItem(product.id);

    if (existingItem != null) {
      existingItem.quantity++;
      await localDataSource.addOrUpdateItem(existingItem);
    } else {
      final newItem = CartItemEntity(product: product, quantity: 1);
      await localDataSource.addOrUpdateItem(newItem);
    }
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearAll();
  }

  @override
  ValueListenable<Box<CartItemEntity>> getCartListenable() {
    return localDataSource.getCartListenable();
  }

  @override
  List<CartItemEntity> getCartItems() {
    return localDataSource.getAllItems();
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    await localDataSource.removeItem(productId);
  }

  @override
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    final item = localDataSource.getItem(productId);
    if (item != null) {
      if (newQuantity > 0) {
        item.quantity = newQuantity;
        await localDataSource.addOrUpdateItem(item);
      } else {
        await localDataSource.removeItem(productId);
      }
    }
  }
}
