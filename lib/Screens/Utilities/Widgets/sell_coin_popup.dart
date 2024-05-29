// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';

import 'package:cryptbee/Config/api_integration.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/but_sell_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/log_in_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toast/toast.dart';

import '../Riverpod/riverpod_variables.dart';

class SellCoinPopup extends ConsumerWidget {
  dynamic data;
  SellCoinPopup({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinQuantity = ref.watch(coinPageCoinControllerProvider) ?? 0;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Center(
          child: Container(
            height: 400,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05)),
            child: Center(
              child: Container(
                color: Palette.secondaryBlackColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: const Icon(
                              Icons.close_sharp,
                              color: Palette.secondaryOffWhiteColor,
                            ),
                            onPressed: () {
                              coinPagePopupNotifier.close();
                              coinPageCoinControllerNotifier.setVal("1");
                            }),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        "Do You Want To Buy",
                        style: titleMedium(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Current Price     ₹${data['price'].toStringAsFixed(2)}",
                        style: bodyLarge(),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onChanged: (text) {
                          coinPageCoinControllerNotifier.setVal(text);
                        },
                        keyboardType: TextInputType.number,
                        style: bodyMedium(),
                        decoration: InputDecoration(
                          counterText: "",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: bodyMedium(),
                          labelText: "Quantity",
                          hintText: "Enter the Quatity",
                          labelStyle: labelMedium(),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: Palette.secondaryOffWhiteColor,
                                  width: 2)),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: Palette.secondaryOffWhiteColor,
                                  width: 2)),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: Palette.secondaryOffWhiteColor,
                                  width: 2)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: Palette.secondaryOffWhiteColor,
                                  width: 2)),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: Palette.secondaryOffWhiteColor,
                                  width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Brokerage",
                            style: bodyLarge(),
                          ),
                          Text(
                            "₹${coinQuantity < data['DiscountThreshold'] ? data['StandardCommissionRate'] : data['DiscountedCommissionRate']}",
                            style: bodyLarge(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: bodyLarge(),
                          ),
                          Text(
                            "₹${(coinQuantity * data['price']) + (coinQuantity < data['DiscountThreshold'] ? data['StandardCommissionRate'] : data['DiscountedCommissionRate'])}",
                            style: bodyLarge(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BuySellButton(
                        loaderProvider: coinPageButtonLoaderProvider,
                        text: "Sell",
                        height: 50,
                        function: () async {
                          coinPageButtonLoaderNotifier.toggle();
                          final output = await ApiCalls.sellCoin(
                              ref.watch(coinPageCoinControllerProvider) ?? 1,
                              data['price'],
                              data['_id']);

                          log(output.toString());

                          if (output['statusCode'] == 201) {
                            coinPagePopupNotifier.close();
                            ToastContext().init(context);
                            Toast.show(output[output.keys.first],
                                duration: 5, gravity: Toast.bottom);
                          } else {
                            ToastContext().init(context);
                            Toast.show(output[output.keys.first],
                                duration: 5, gravity: Toast.bottom);
                          }
                          coinPageButtonLoaderNotifier.toggle();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
