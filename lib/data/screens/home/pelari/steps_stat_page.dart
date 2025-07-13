import 'package:fitsteps_app/data/blocs/steps_stat/steps_stat_bloc.dart';
import 'package:fitsteps_app/data/blocs/steps_stat/steps_stat_event.dart';
import 'package:fitsteps_app/data/blocs/steps_stat/steps_stat_state.dart';
import 'package:fitsteps_app/data/services/StepsStatService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepsStatPage extends StatelessWidget {
  final String token;

  const StepsStatPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StepsStatBloc(StepsStatService())..add(LoadWeeklySteps(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Statistik Mingguan')),
        body: BlocBuilder<StepsStatBloc, StepsStatState>(
          builder: (context, state) {
            if (state is StepsStatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StepsStatLoaded) {
              final stats = state.stats;
              final sortedKeys = stats.keys.toList()..sort();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < sortedKeys.length) {
                              final date = sortedKeys[value.toInt()];
                              return Text(
                                date.substring(5),
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          reservedSize: 32,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(sortedKeys.length, (index) {
                      final date = sortedKeys[index];
                      final value = stats[date] ?? 0;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value.toDouble(),
                            color: Colors.green,
                            width: 16,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            } else if (state is StepsStatError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
