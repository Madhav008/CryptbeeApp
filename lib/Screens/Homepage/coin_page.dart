// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptbee/Config/api_integration.dart';
import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Screens/Utilities/Riverpod/riverpod_variables.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/but_sell_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/buy_coin_popup.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/sell_coin_popup.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cryptbee/Screens/Utilities/Widgets/auth_heading.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/log_in_button.dart';
import 'package:cryptbee/Screens/Utilities/Widgets/utilities.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CoinPage extends ConsumerStatefulWidget {
  CoinPage({super.key, required this.shortName});
  final String shortName;
  List<CoinData> chartData = [];
  ChartSeriesController? chartSeriesController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoinPageState();
}

class _CoinPageState extends ConsumerState<CoinPage> {
  @override
  void _parseChartData(List<dynamic> chart) {
    widget.chartData = chart.map((data) {
      return CoinData(DateTime.parse(data['date']), data['price'].toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    App.currentCoin = widget.shortName;
    final singleCoinsAsyncValue = ref.watch(getCoinDetailProvider);

    return singleCoinsAsyncValue.when(
      data: (data) {
        data = data['data'];
        print(data);
        // Parse the chart data
        widget.chartData = (data['chart'] as List<dynamic>).map((chartItem) {
          final date = DateTime.parse(chartItem['date']);
          final price = chartItem['price'].toDouble();
          return CoinData(date, price);
        }).toList();
        return Scaffold(
          backgroundColor: Palette.secondaryBlackColor,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 38),
                        GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: Icon(
                                    Icons.chevron_left_sharp,
                                    color: Palette.secondaryOffWhiteColor,
                                  ),
                                ),
                                authTitleMediumText("Back")
                              ],
                            )),
                        const SizedBox(height: 29),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 19,
                              backgroundImage: CachedNetworkImageProvider(
                                data['image'],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                widget.shortName,
                                style: titleLarge(),
                              ),
                            )
                          ],
                        ),
                        Center(
                            child: SizedBox(
                          height: 325,
                          child: Center(
                            child: SfCartesianChart(
                              enableAxisAnimation: true,
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat.Hms(),
                                majorGridLines: const MajorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  majorGridLines:
                                      const MajorGridLines(width: 0)),
                              zoomPanBehavior:
                                  ZoomPanBehavior(enablePanning: true),
                              series: <ChartSeries>[
                                FastLineSeries<CoinData, DateTime>(
                                  onRendererCreated: (series) {
                                    widget.chartSeriesController = series;
                                  },
                                  dataSource: widget.chartData,
                                  xValueMapper: (CoinData data, _) => data.time,
                                  yValueMapper: (CoinData data, _) => data.data,
                                )
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 25),
                        SizedBox(
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Prices", style: titleMedium()),
                              Text("₹ ${data['price'].toStringAsFixed(2)}",
                                  style: bodyLarge()),
                              Row(
                                children: [
                                  (data['changePercent'] >= 0)
                                      ? const Icon(Icons.arrow_upward_rounded,
                                          color: Palette.secondaryCorrectColor)
                                      : const Icon(Icons.arrow_downward_rounded,
                                          color: Palette.secondaryErrorColor),
                                  Text(
                                    "${data['changePercent'].toStringAsFixed(2)} %",
                                    style: bodyLarge(
                                        fontColor: (data['changePercent'] >= 0)
                                            ? Palette.secondaryCorrectColor
                                            : Palette.secondaryErrorColor),
                                  ),
                                ],
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (ref.watch(inWatchlistBoolProvider)) {
                                    ApiCalls.modifyWatchlist("remove");
                                  } else {
                                    ApiCalls.modifyWatchlist("add");
                                  }
                                  inWatchListBoolNotifier.toggle();
                                },
                                icon: Icon(
                                  ref.watch(inWatchlistBoolProvider) ?? false
                                      ? Icons.bookmark_sharp
                                      : Icons.bookmark_border_sharp,
                                  color: Palette.secondaryOffWhiteColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        authBodyLarge("About"),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 148,
                          child: SingleChildScrollView(
                            child: data['info'] == null
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Palette.primaryColor,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      data['info'],
                                      style: bodyLarge(),
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  child: BuySellButton(
                                    text: "Buy",
                                    height: 50,
                                    function: () {
                                      coinPagePopupNotifier.buy();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  child: BuySellButton(
                                    text: "Sell",
                                    height: 50,
                                    function: () {
                                      coinPagePopupNotifier.sell();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  ref.watch(coinPagePopUpProvider) == 'buy'
                      ? BuyCoinPopup(data: data)
                      : (ref.watch(coinPagePopUpProvider) == 'sell'
                          ? SellCoinPopup(data: data)
                          : const SizedBox())
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(
          error.toString(),
          style: titleLarge(),
        );
      },
      loading: () {
        return const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(color: Palette.primaryColor),
            ),
          ),
        );
      },
    );
  }
}

class CoinData {
  CoinData(this.time, this.data);
  final DateTime time;
  final double data;
}
