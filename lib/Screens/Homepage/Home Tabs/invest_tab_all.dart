import 'package:cryptbee/Models/coin_model.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/invest_coin_tile_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/auth_heading.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/my_holding_small_tile_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';

class InvestTabAll extends ConsumerWidget {
  const InvestTabAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCoinsAsyncValue = ref.watch(getHoldingsProvider);
    // ref.invalidate(getHoldingsProvider);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            'IPO Scripts',
            style: TextStyle(
              color: Palette.secondaryWhiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: allCoinsAsyncValue.when(
            data: (data) {
              return ListView.builder(
                itemCount: data['ipos'].length,
                itemBuilder: (context, index) {
                  return InvestCoinTileBuilder(
                    coin: Coin(
                      fullName: data['ipos'][index]['fullName'],
                      shortForm: data['ipos'][index]['shortForm'],
                      image: data['ipos'][index]['image'],
                      price: data['ipos'][index]['price'] + 0.0,
                      changePercent: data['ipos'][index]['changePercent'] + 0.0,
                    ),
                  );
                },
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
          ),
        ),
      ],
    );
  }
}
