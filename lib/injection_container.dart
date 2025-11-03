import 'package:get_it/get_it.dart';
import 'core/domain/repositories/i_cart_repository.dart';
import 'core/domain/repositories/i_product_repository.dart';
import 'features/cart/data/datasources/cart_local_datasource.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

final sl = GetIt.instance; // sl = Service Locator

void init() {
  // Features - Cart
  // Repository
  sl.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  // Data Source
  sl.registerLazySingleton(() => CartLocalDataSource());

  // Features - Product
  // Repository
  sl.registerLazySingleton<IProductRepository>(
    () => ProductRepositoryImpl(), // Using our mock implementation
  );
}
