import 'package:cart_prec/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:cart_prec/features/cart/presentation/widgets/cart_icon.dart';
import 'package:cart_prec/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [
          CartIcon(), // This widget will also be updated
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is ProductLoadedState) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),

                  // This trailing widget listens to the CartBloc
                  trailing: BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoadedState) {
                        final quantity = cartState.getQuantity(product.id);

                        if (quantity == 0) {
                          // NOT IN CART
                          return IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              // Add Event to CartBloc
                              context.read<CartBloc>().add(
                                AddProductToCartEvent(product),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        } else {
                          // IN CART: Show + and -
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Add Event to CartBloc
                                  context.read<CartBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product.id,
                                      quantity - 1,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  // Add Event to CartBloc
                                  context.read<CartBloc>().add(
                                    AddProductToCartEvent(product),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      }
                      // Show a compact loader while cart is loading
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
