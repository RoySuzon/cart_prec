import 'package:cart_prec/core/domain/repositories/i_cart_repository.dart';
import 'package:cart_prec/core/domain/repositories/i_product_repository.dart';
import 'package:cart_prec/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:cart_prec/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:cart_prec/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:cart_prec/features/product/data/repositories/product_repository_impl.dart';
import 'package:cart_prec/features/product/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance; // sl = Service Locator

void init() {
  // --- BLoCs ---
  // We use registerFactory for Blocs so a new instance is created
  sl
    ..registerFactory(
      () => ProductBloc(productRepository: sl()),
    )
    // We use registerLazySingleton for CartBloc because we want ONE cart state
    ..registerLazySingleton(
      () => CartBloc(cartRepository: sl()),
    )
    // --- Repositories ---
    ..registerLazySingleton<ICartRepository>(
      () => CartRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<IProductRepository>(
      ProductRepositoryImpl.new,
    )
    // --- Data Sources ---
    ..registerLazySingleton(CartLocalDataSource.new);
}
