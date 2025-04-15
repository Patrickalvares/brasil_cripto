import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common_widgets/error_message.dart';
import 'coin_detail_state.dart';
import 'coin_detail_viewmodel.dart';

class CoinDetailView extends StatefulWidget {
  final String coinId;

  const CoinDetailView({super.key, required this.coinId});

  @override
  State<CoinDetailView> createState() => _CoinDetailViewState();
}

class _CoinDetailViewState extends State<CoinDetailView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinDetailViewModel>().carregarDetalhesMoeda(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('coin_details'.tr()),
        actions: [
          Consumer<CoinDetailViewModel>(
            builder: (context, viewModel, _) {
              final state = viewModel.state;

              if (state.status == DetailStatus.carregado) {
                return IconButton(
                  icon: Icon(
                    state.eFavorito ? Icons.star : Icons.star_border,
                    color: state.eFavorito ? Colors.amber : null,
                  ),
                  onPressed: () {
                    viewModel.alternarFavorito();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CoinDetailViewModel>(
        builder: (context, viewModel, _) {
          final state = viewModel.state;

          if (state.status == DetailStatus.inicial || state.status == DetailStatus.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DetailStatus.erro) {
            return ErrorMessage(
              message: state.mensagemErro,
              onRetry: () => viewModel.carregarDetalhesMoeda(widget.coinId),
            );
          }

          final moeda = state.detalheMoeda!;

          return RefreshIndicator(
            onRefresh: () => viewModel.carregarDetalhesMoeda(widget.coinId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (moeda.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                imageUrl: moeda.image!,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                moeda.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                moeda.symbol.toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    _buildPriceInfo(context, moeda),

                    const SizedBox(height: 32),

                    if (moeda.sparklineData != null && moeda.sparklineData!.isNotEmpty)
                      _buildPriceChart(context, moeda),

                    const SizedBox(height: 32),

                    _buildMarketStats(context, moeda),

                    const SizedBox(height: 24),

                    if (moeda.description != null && moeda.description!.isNotEmpty) ...[
                      Text(
                        'about_coin'.tr(namedArgs: {'name': moeda.name}),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _cleanDescription(moeda.description!),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, moeda) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final isPositiveChange = (moeda.priceChangePercentage24h ?? 0) >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              moeda.currentPrice != null ? formatter.format(moeda.currentPrice) : '-',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (moeda.priceChangePercentage24h != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositiveChange ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${moeda.priceChangePercentage24h! >= 0 ? '+' : ''}${moeda.priceChangePercentage24h!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositiveChange ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'price_change_24h'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPriceChart(BuildContext context, moeda) {
    final isPositiveChange = (moeda.priceChangePercentage24h ?? 0) >= 0;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price_chart_7d'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(moeda.sparklineData!),
                  isCurved: true,
                  color: isPositiveChange ? Colors.green : Colors.red,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: isPositiveChange ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.surface,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      return LineTooltipItem(
                        formatter.format(touchedSpot.y),
                        TextStyle(
                          color: isPositiveChange ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketStats(BuildContext context, moeda) {
    final formatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('market_stats'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildStatRow(
          context,
          'market_cap'.tr(),
          moeda.marketCap != null ? formatter.format(moeda.marketCap) : '-',
        ),
        _buildStatRow(
          context,
          'volume_24h'.tr(),
          moeda.totalVolume != null ? formatter.format(moeda.totalVolume) : '-',
        ),
        _buildStatRow(
          context,
          'market_rank'.tr(),
          moeda.marketCapRank != null ? '#${moeda.marketCapRank}' : '-',
        ),
        _buildStatRow(
          context,
          'high_24h'.tr(),
          moeda.high24h != null ? formatter.format(moeda.high24h) : '-',
        ),
        _buildStatRow(
          context,
          'low_24h'.tr(),
          moeda.low24h != null ? formatter.format(moeda.low24h) : '-',
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createSpots(List<double> data) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }
    return spots;
  }

  String _cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}
