// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';

import 'package:cryptbee/Config/api_integration.dart';
import 'package:cryptbee/Models/coin_model.dart';
import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/watchlist_coin_tile_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/log_in_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';

class InvestTabWatchlist extends ConsumerWidget {
  InvestTabWatchlist({super.key});
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCoinsAsyncValue = ref.watch(getOrdersHistory);
    // ref.invalidate(getOrdersHistory);
    return allCoinsAsyncValue.when(
      data: (data) {
        data = data['orders'];
        print(data);
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 194,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    return ((index) != (data.length))
                        ? GestureDetector(
                            onTap: () {
                              context.goNamed(RouteNames.coinPage,
                                  pathParameters: {
                                    "shortName": App.currentCoin!
                                  });
                            },
                            child: WatchlistCoinTileBuilder(
                                coin: Coin(
                                  fullName: data[index]['fullName'],
                                  shortForm: data[index]['shortForm'],
                                  image: data[index]['image'],
                                  type: data[index]['orderType'],
                                  holding: data[index]['quantity'] + 0.0,
                                  commision:data[index]['commissionPaid'] + 0.0,
                                  price: data[index]['price'] + 0.0,
                                  orderPrice: data[index]['priceAtOrder'] + 0.0,
                                  closedPrice: data[index]['closedPrice'] + 0.0,
                                ),
                                index: index),
                          )
                        : (index == 0)
                            ? SizedBox(
                                height: 84,
                                child: Center(
                                  child: Text(
                                    "No Watchlist Sadly   :C",
                                    style: titleMedium(),
                                  ),
                                ),
                              )
                            : Container(
                                height: 84,
                              );
                  },
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
            child: Text(
          error.toString(),
          style: headlineLarge(),
        ));
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Palette.primaryColor),
      ),
    );
  }
}
