import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartLocalDataSource {
  CartLocalDataSource() : _box = Hive.box<CartItemEntity>(_boxName);
  static const String _boxName = 'cartBox';
  final Box<CartItemEntity> _box;

  ValueListenable<Box<CartItemEntity>> getCartListenable() {
    return _box.listenable();
  }

  Future<void> addOrUpdateItem(CartItemEntity item) async =>
      _box.put(item.product.id, item);

  Future<void> removeItem(String productId) async {
    await _box.delete(productId);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  CartItemEntity? getItem(String productId) {
    return _box.get(productId);
  }

  List<CartItemEntity> getAllItems() {
    return _box.values.toList();
  }
}
