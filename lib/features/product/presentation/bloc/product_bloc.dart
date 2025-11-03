import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/core/domain/repositories/i_product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.productRepository})
    : super(ProductLoadingState()) {
    on<LoadProductsEvent>(_onLoadProducts);
  }
  final IProductRepository productRepository;

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      final products = await productRepository.getProducts();
      emit(ProductLoadedState(products));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }
}
