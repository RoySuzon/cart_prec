import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cart_prec/core/domain/entities/cart_item_entity.dart';
import 'package:cart_prec/core/domain/entities/product_entity.dart';
import 'package:cart_prec/injection_container.dart' as di;
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  // 2. Register Adapters (Import from core module)
  Hive
    ..registerAdapter(ProductEntityAdapter())
    ..registerAdapter(CartItemEntityAdapter());

  // 3. Open the cart box
  await Hive.openBox<CartItemEntity>('cartBox');

  // 4. Initialize Dependency Injection
  di.init();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}
