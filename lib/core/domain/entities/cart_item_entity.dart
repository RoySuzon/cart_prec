import 'package:hive/hive.dart';
import 'product_entity.dart';

part 'cart_item_entity.g.dart';

@HiveType(typeId: 1)
class CartItemEntity extends HiveObject {
  @HiveField(0)
  final ProductEntity product;

  @HiveField(1)
  int quantity;

  CartItemEntity({
    required this.product,
    this.quantity = 1,
  });
}