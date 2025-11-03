import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_cart_repository.dart';
import 'package:cart_prec/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve the dependency
    final cartRepository = sl<ICartRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: cartRepository.clearCart,
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<CartItemEntity>>(
        valueListenable: cartRepository.getCartListenable(),
        builder: (context, box, _) {
          final cartItems = box.values.toList();

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final double totalPrice = cartItems.fold(
            0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );

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
                            onPressed: () =>
                                cartRepository.updateProductQuantity(
                                  item.product.id,
                                  item.quantity - 1,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () =>
                                cartRepository.updateProductQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                ),
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
        },
      ),
    );
  }
}
