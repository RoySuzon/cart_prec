part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductEntity> products;
  const ProductLoadedState(this.products);
  @override
  List<Object> get props => [products];
}

class ProductErrorState extends ProductState {
  final String message;
  const ProductErrorState(this.message);
  @override
  List<Object> get props => [message];
}
