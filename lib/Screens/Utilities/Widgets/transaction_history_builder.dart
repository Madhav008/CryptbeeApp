// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionHistoryBuilder extends ConsumerWidget {
  final Map<String, dynamic> history;

  TransactionHistoryBuilder({super.key, required this.history});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> transaction = history;
    final String activity = transaction['type'];
    final String quantity = transaction['amount'].toString();
    final String shortName = transaction['description'];
    final DateTime createdAt = DateTime.parse(transaction['createdAt']);
    final String monthDate =
        createdAt.toLocal().month.toString().padLeft(2, '0');
    final String year = createdAt.year.toString();
    final String price = transaction['amount'].toString();

    print("$activity $quantity $shortName $monthDate $year $price");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 9,
        decoration: const BoxDecoration(
          color: Palette.neutralBlack,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SvgPicture.asset(
                activity == 'credit'
                    ? "assests/illustrations/bought_icon.svg"
                    : "assests/illustrations/sold_icon.svg",
                height: 31,
                width: 31,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ $price",
                        style: bodyMedium(
                            fontColor: Palette.secondaryOffWhiteColor),
                      ),
                      Text(
                        "$quantity $shortName",
                        style: bodyMedium(fontColor: Palette.neutralGrey),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    activity,
                    style:
                        bodyMedium(fontColor: Palette.secondaryOffWhiteColor),
                  ),
                  Text("$monthDate, $year",
                      style: bodyMedium(
                        fontColor: Palette.neutralGrey,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
