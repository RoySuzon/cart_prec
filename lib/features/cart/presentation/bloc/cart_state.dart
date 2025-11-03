part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemEntity> cartItems;
  final double totalPrice;
  final int totalItemCount;

  const CartLoadedState({
    this.cartItems = const [],
    this.totalPrice = 0.0,
    this.totalItemCount = 0,
  });
  
  // Helper function to get quantity for a specific product
  int getQuantity(String productId) {
    try {
      return cartItems.firstWhere((item) => item.product.id == productId).quantity;
    } catch (e) {
      return 0; // Not found
    }
  }

  @override
  List<Object> get props => [cartItems, totalPrice, totalItemCount];
}

class CartErrorState extends CartState {
  final String message;
  const CartErrorState(this.message);
  @override
  List<Object> get props => [message];
}