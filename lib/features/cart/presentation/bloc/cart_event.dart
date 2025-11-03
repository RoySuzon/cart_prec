part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

/// Tells the BLoC to load the cart from the repository.
class LoadCartEvent extends CartEvent {}

/// Tells the BLoC to add or increment a product.
class AddProductToCartEvent extends CartEvent {
  final ProductEntity product;
  const AddProductToCartEvent(this.product);
  @override
  List<Object> get props => [product];
}

/// Tells the BLoC to update a product's quantity (can be 0 to remove).
class UpdateCartQuantityEvent extends CartEvent {
  final String productId;
  final int newQuantity;
  const UpdateCartQuantityEvent(this.productId, this.newQuantity);
  @override
  List<Object> get props => [productId, newQuantity];
}

/// Tells the BLoC to clear the cart.
class ClearCartEvent extends CartEvent {}