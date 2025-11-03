import 'package:cart_prec/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:cart_prec/features/product/presentation/bloc/product_bloc.dart';
import 'package:cart_prec/features/product/presentation/screens/product_list_screen.dart';
import 'package:cart_prec/injection_container.dart';
import 'package:cart_prec/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(LoadProductsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<CartBloc>()..add(LoadCartEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListScreen(),
    ),
    // GoRoute(
    //   path: '/cart',
    //   builder: (context, state) => const CartPage(),
    // ),
  ],
);
