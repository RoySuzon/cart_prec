import 'package:cart_prec/core/domain/entities/cart_item_entity.dart'; // Import CartItemEntity
import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_cart_repository.dart';
import 'package:cart_prec/core/domain/repositories/i_product_repository.dart';
import 'package:cart_prec/features/cart/presentation/widgets/cart_icon.dart';
import 'package:cart_prec/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final IProductRepository productRepo = sl<IProductRepository>();
  final ICartRepository cartRepo =
      sl<ICartRepository>(); // We'll use this in the builder

  late Future<List<ProductEntity>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = productRepo.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [
          CartIcon(),
        ],
      ),
      body: FutureBuilder<List<ProductEntity>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          // --- This ListView.builder is the changed part ---
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),

                // ---- HERE IS THE NEW LOGIC ----
                trailing: ValueListenableBuilder(
                  valueListenable: cartRepo.getCartListenable(),
                  builder: (context, Box<CartItemEntity> box, _) {
                    // Find this specific product in the cart
                    final cartItem = box.get(product.id);
                    final quantity = cartItem?.quantity ?? 0;

                    if (quantity == 0) {
                      // NOT IN CART: Show "Add" button
                      return IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () async {
                          await cartRepo.addProductToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    } else {
                      // IN CART: Show Increment/Decrement controls
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              // This will remove it if quantity hits 0
                              await cartRepo.updateProductQuantity(
                                product.id,
                                quantity - 1,
                              );
                            },
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              // Our addProductToCart handles incrementing
                              await cartRepo.addProductToCart(product);
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                // ---- END OF NEW LOGIC ----
              );
            },
          );
          // --- End of change ---
        },
      ),
    );
  }
}
