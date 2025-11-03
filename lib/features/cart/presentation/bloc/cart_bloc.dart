import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository}) : super(CartLoadingState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddProductToCartEvent>(_onAddProduct);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }
  final ICartRepository cartRepository;

  // Helper method to get items, calculate totals, and emit a new state
  Future<void> _reloadCart(Emitter<CartState> emit) async {
    try {
      final items = cartRepository.getCartItems();
      var newTotalPrice = 0.0;
      var newItemCount = 0;

      for (final item in items) {
        newTotalPrice += item.product.price * item.quantity;
        newItemCount += item.quantity;
      }

      emit(
        CartLoadedState(
          cartItems: items,
          totalPrice: newTotalPrice,
          totalItemCount: newItemCount,
        ),
      );
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoadingState());
    await _reloadCart(emit);
  }

  Future<void> _onAddProduct(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    await cartRepository.addProductToCart(event.product);
    await _reloadCart(emit);
  }

  Future<void> _onUpdateQuantity(
    UpdateCartQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    await cartRepository.updateProductQuantity(
      event.productId,
      event.newQuantity,
    );
    await _reloadCart(emit);
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    await cartRepository.clearCart();
    await _reloadCart(emit);
  }
}
