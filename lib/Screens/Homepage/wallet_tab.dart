import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/transaction_history_builder.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletTab extends ConsumerWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.invalidate(getWalletProvider);
    final orderdata = ref.watch(getOrdersProvider);
    final preparedData = orderdata.when(
      data: (data) {
        return data;
      },
      loading: () {
        return null;
      },
      error: (error, stackTrace) {
        return null;
      },
    );
    print("----------------------------------------------------");
    double totalHoldingAmount = 0;
    double totalProfitnLoss = 0;

    // Iterate over orders
    for (var order in preparedData['orders']) {
      final double quantity = order['quantity'] + 0.0;
      final double priceAtOrder = order['priceAtOrder'] + 0.0;
      final double currentPrice = order['price'] + 0.0;

      // Calculate total holding amount
      totalHoldingAmount += quantity * priceAtOrder;

      // Calculate total profit and loss
      //To calculate the totalProfit and totalLoss we need to check the type of order first
      if (order['type'] == "Buy") {
        totalProfitnLoss += quantity * (currentPrice - priceAtOrder);
      }
      if (order['type'] == "Sell") {
        final profit = quantity * (currentPrice - priceAtOrder);
        totalProfitnLoss += (profit * -1);
      }
    }

    print(totalHoldingAmount);
    print(totalProfitnLoss);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            child: ref.watch(getWalletProvider).when(
                  data: (data) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                (totalProfitnLoss) > 0
                                    ? "Total Profit"
                                    : "Total Loss",
                                style: headlineSmall(
                                  fontColor: Palette.primaryColor,
                                )),
                            Text(
                              "₹ ${(totalProfitnLoss.toStringAsFixed(2))}",
                              style: headlineSmall(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total Wallet Balance",
                            style: labelSmall(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ ${data['balance'].toStringAsFixed(2)} ",
                            style: headlineLarge(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total Standings",
                            style: labelSmall(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ ${totalHoldingAmount.toStringAsFixed(2)}",
                            style: headlineLarge(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                  error: ((error, stackTrace) => Center(
                        child: Text(error.toString()),
                      )),
                  loading: () => const SizedBox(
                    height: 148,
                    width: double.infinity,
                    child: Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                                color: Palette.primaryColor))),
                  ),
                ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Transaction History",
              style: titleLarge(),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 332,
                  child: ref.watch(transactionsProvider).when(
                        data: (data) {
                          data = data['userTransactions'];
                          return ListView.builder(
                            itemCount: data.length + 1,
                            itemBuilder: (context, index) {
                              return (index != data.length)
                                  ? TransactionHistoryBuilder(
                                      history: data[index])
                                  : Container(
                                      height: 58,
                                    );
                            },
                          );
                        },
                        error: (error, stackTrace) => Center(
                          child: Text(error.toString()),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
