import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class ICartRepository {
  Future<void> addProductToCart(ProductEntity product);
  Future<void> removeProductFromCart(String productId);
  Future<void> updateProductQuantity(String productId, int newQuantity);
  Future<void> clearCart();
  ValueListenable<Box<CartItemEntity>> getCartListenable();
  List<CartItemEntity> getCartItems();
}
