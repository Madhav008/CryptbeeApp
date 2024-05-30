import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptbee/Models/coin_model.dart';
import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/but_sell_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvestCoinTileBuilder extends ConsumerWidget {
  final Coin coin;
  const InvestCoinTileBuilder({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 26),
      child: GestureDetector(
        onTap: () {
          App.currentCoin = coin.shortForm;
          ref.invalidate(getCoinDetailProvider);
          context.goNamed(RouteNames.coinPage,
              pathParameters: {'shortName': coin.shortForm});
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Palette.secondaryBlackColor,
            //Add the border at bottom
            border: Border(
                left: BorderSide(
                    width: 0.3, color: Palette.secondaryOffWhiteColor)),

            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 32,
                  backgroundImage: CachedNetworkImageProvider(
                    coin.image,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coin.fullName,
                                  style: TextStyle(
                                    fontSize: coin.fullName.length < 20
                                        ? coin.fullName.length < 15
                                            ? 18
                                            : 12
                                        : 10,
                                    color: Palette.secondaryOffWhiteColor,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  coin.shortForm,
                                  style: labelMedium(),
                                )
                              ],
                            ),
                            Text(
                              "₹ ${coin.price.toStringAsFixed(2)}",
                              style: bodyLarge(),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                coin.changePercent! > 0
                                    ? const Icon(Icons.arrow_upward_rounded,
                                        color: Palette.secondaryCorrectColor)
                                    : const Icon(Icons.arrow_downward_rounded,
                                        color: Palette.secondaryErrorColor),
                                Text(
                                  "${coin.changePercent!.toStringAsFixed(2)} %",
                                  style: bodyMedium(
                                      fontColor: coin.changePercent! > 0
                                          ? Palette.secondaryCorrectColor
                                          : Palette.secondaryErrorColor),
                                ),
                              ],
                            ),
                            Row(children: [
                              Text(
                                "View More",
                                style: bodySmall(),
                              ),
                              const Icon(
                                Icons.chevron_right_sharp,
                                color: Colors.white,
                              )
                            ])
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       BuySellButton(
                        //         text: "Buy",
                        //         width: 112,
                        //         function: () {
                        //           App.currentCoin = coin.shortForm;

                        //         },
                        //       ),
                        //       BuySellButton(
                        //         text: "Sell",
                        //         width: 112,
                        //         function: () {
                        //           App.currentCoin = coin.shortForm;

                        //         },
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
