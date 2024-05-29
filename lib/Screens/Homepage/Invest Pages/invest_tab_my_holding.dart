// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'package:cryptbee/Config/api_integration.dart';
import 'package:cryptbee/Models/coin_model.dart';
import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/holding_coin_tile_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/log_in_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';

class InvestTabMyHoldings extends ConsumerWidget {
  InvestTabMyHoldings({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCoinsAsyncValue = ref.watch(getOrdersProvider);
    return allCoinsAsyncValue.when(
      data: (data) {
        data = data['orders'];
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 194,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var changePercent = data[index]['priceAtOrder'] == 0
                        ? 0
                        : ((data[index]['price'] -
                                    data[index]['priceAtOrder']) /
                                data[index]['price']) *
                            100;
                    return ((index) == (data.length))
                        ? (index == 0)
                            ? SizedBox(
                                height: 84,
                                child: Center(
                                  child: Text(
                                    "No Holdings Sadly   :)",
                                    style: titleMedium(),
                                  ),
                                ),
                              )
                            : Container(
                                height: 84,
                              )
                        : holdingCoinTileBuilder(
                            Coin(
                              fullName: data[index]['fullName'],
                              shortForm: data[index]['shortForm'],
                              image: data[index]['image'],
                              type: data[index]['orderType'],
                              price: data[index]['price'] + 0.0,
                              holding: data[index]['quantity'] + 0.0,
                              changePercent: changePercent + 0.0,
                              orderPrice: data[index]['priceAtOrder'] + 0.0,
                              commision: data[index]['commissionPaid'] + 0.0,
                            ),
                            index);
                  },
                ),
                ref.watch(holdingTabPopUpProvider)
                    ? SizedBox(
                        height: 420,
                        // width: double.infinity,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05)),
                            child: Center(
                              child: Container(
                                color: Palette.secondaryBlackColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            icon: const Icon(
                                              Icons.close_sharp,
                                              color: Palette
                                                  .secondaryOffWhiteColor,
                                            ),
                                            onPressed: () {
                                              holdingTabPopupNotifier.toggle();
                                            }),
                                      ),
                                      const SizedBox(height: 9),
                                      Text(
                                        "Do You Want To Close The Position?",
                                        style: titleSmall(),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "Ordered Price     ₹${data[App.holdingIndex]['priceAtOrder']}",
                                        style: bodyLarge(),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "Current Price     ₹${data[App.holdingIndex]['price']}",
                                        style: bodyLarge(),
                                      ),
                                      const SizedBox(height: 30),
                                      Text(
                                        "Total Profit/Loss   ₹${(data[App.holdingIndex]['price'] - data[App.holdingIndex]['priceAtOrder']).toStringAsFixed(2)}",
                                        style: bodyLarge(),
                                      ),
                                      const SizedBox(height: 20),
                                      LogInButton(
                                        loaderProvider:
                                            holdingTabButtonLoaderProvider,
                                        text: "Close",
                                        function: () async {
                                          holdingTabButtonLoaderNotifier
                                              .toggle();

                                          final output =
                                              await ApiCalls.closeOrder(
                                                  data[App.holdingIndex]
                                                      ['orderId']);
                                          if (output['statusCode'] == 200) {
                                            ToastContext().init(context);
                                            Toast.show(
                                                output[output.keys.first],
                                                duration: 5,
                                                gravity: Toast.bottom);
                                          } else {
                                            ToastContext().init(context);
                                            Toast.show(
                                                output[output.keys.first],
                                                duration: 5,
                                                gravity: Toast.bottom);
                                          }
                                          ref.invalidate(getOrdersProvider);
                                          holdingTabPopupNotifier.toggle();

                                          holdingTabButtonLoaderNotifier
                                              .toggle();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
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
