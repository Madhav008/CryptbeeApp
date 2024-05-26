// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cryptbee/Models/news_model.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/auth_heading.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/cypto_news_item_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/my_holding_small_tile_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabPan extends ConsumerWidget {
  const HomeTabPan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final news = ref.watch(getNewsProvider);
    final holdings = ref.watch(getHoldingsProvider);
    // final investTabIndex = ref.watch(investTopNavProvider);

    // ref.invalidate(getHoldingsProvider);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            authTitleMediumText("My Holdings"),
            const SizedBox(height: 24),
            holdings.when(
              data: (data) {
                // print(data);
                return SizedBox(
                  height: data['matches'].length <= 4 ? 74 : 148,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                      data['matches'].length < 5
                          ? 4
                          : min(data['matches'].length, 8),
                      (index) {
                        if (data['matches'].length == 0) {
                          if (index == 0) {
                            return Center(
                              child: Text(
                                "No Coins , Go Buy Some",
                                style: titleMedium(),
                              ),
                            );
                          } else {
                            return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 12),
                                child: SizedBox(
                                  width: 40,
                                ));
                          }
                        } else if (data['matches'].length < 4) {
                          if ((index + 1) > data['matches'].length) {
                            return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 12),
                                child: SizedBox(
                                  width: 40,
                                ));
                          } else {
                            final coinSmallName =
                                data['matches'][index]['team1logo'];
                            final coinImage =
                                data['matches'][index]['team2logo'];
                            return MyyHoldingSmallTileBuilder(
                              image: coinImage,
                              shortname: coinSmallName,
                            );
                          }
                        } else {
                          final coinSmallName =
                              data['matches'][index]['team1display'];
                          final coinImage = data['matches'][index]['team2logo'];
                          return MyyHoldingSmallTileBuilder(
                            image: coinImage,
                            shortname: coinSmallName,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 74,
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child:
                        CircularProgressIndicator(color: Palette.primaryColor),
                  ),
                ),
              ),
              error: (error, stackTrace) => SizedBox(
                height: 74,
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: Text(
                      error.toString(),
                      style: titleLarge(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
