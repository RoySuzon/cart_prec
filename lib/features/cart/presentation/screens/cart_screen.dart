import 'package:cart_prec/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Add ClearCartEvent
              context.read<CartBloc>().add(ClearCartEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is CartLoadedState) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty.'));
            }

            final cartItems = state.cartItems;
            final totalPrice = state.totalPrice;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                          'Price: \$${item.product.price.toStringAsFixed(2)}',
                        ),
                        leading: Text(
                          '${item.quantity}x',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                    item.product.id,
                                    item.quantity - 1,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                    item.product.id,
                                    item.quantity + 1,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Total Price Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black26,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Please load the cart.'));
        },
      ),
    );
  }
}
