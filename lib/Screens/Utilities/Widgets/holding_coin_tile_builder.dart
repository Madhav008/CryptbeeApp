import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptbee/Models/coin_model.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/but_sell_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';

Widget holdingCoinTileBuilder(Coin coin, int index, var data) {
  final commision = coin.commision! * (coin.holding ?? 0);
  var profit = (coin.price - coin.orderPrice!) * coin.holding!;

  final currentPrice = data[index]['price'];
  if (coin.type == "Sell") {
    profit = profit * -1;
  }
  var changePercent = coin.price == 0
      ? 0
      : ((coin.price - coin.orderPrice!) / coin.price) * 100;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
    child: SizedBox(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        coin.fullName,
                        style: TextStyle(
                          fontSize: coin.fullName.length < 20
                              ? coin.fullName.length < 15
                                  ? 16
                                  : 10
                              : 8,
                          color: Palette.secondaryOffWhiteColor,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "LTP ₹ ${currentPrice.toStringAsFixed(2)}",
                        style: bodyLarge(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${coin.type!} @ ${coin.orderPrice!}",
                        style: TextStyle(
                          fontSize: 15,
                          color: coin.type == "Buy"
                              ? Palette.secondaryCorrectColor
                              : Palette.secondaryErrorColor,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Brokrage Fee: ${commision.toStringAsFixed(2)}",
                        style: bodySmall(
                          fontColor: Palette.secondaryWhiteColor,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        coin.holding!.toStringAsFixed(2),
                        style: bodyMedium(fontColor: Palette.primaryColor),
                      ),
                      Row(
                        children: [
                          profit! > 0
                              ? const Icon(Icons.arrow_upward_rounded,
                                  color: Palette.secondaryCorrectColor)
                              : const Icon(Icons.arrow_downward_rounded,
                                  color: Palette.secondaryErrorColor),
                          Text(
                            "${profit.toStringAsFixed(2)} ( ${changePercent!.toStringAsFixed(2)}% )",
                            style: bodyMedium(
                                fontColor: profit! > 0
                                    ? Palette.secondaryCorrectColor
                                    : Palette.secondaryErrorColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${coin.status}",
                        style: bodyMedium(
                            fontColor: coin.status == "Pending"
                                ? Palette.secondaryErrorColor
                                : Palette.secondaryCorrectColor),
                      ),
                      BuySellButton(
                        text: "Close",
                        width: 112,
                        function: () {
                          App.holdingIndex = index;
                          App.currentCoin = coin.shortForm;
                          holdingTabPopupNotifier.toggle();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
