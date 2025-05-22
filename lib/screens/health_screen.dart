import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/health_bloc.dart';
import '../models/dividend_record.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  void initState() {
    super.initState();
    // Check health when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthBloc>().add(const CheckHealth());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HealthBloc>().add(const CheckHealth());
            },
          ),
        ],
      ),
      body: BlocBuilder<HealthBloc, HealthState>(
        builder: (context, state) {
          if (state is HealthInitial) {
            return const Center(
              child: Text('Checking health status...'),
            );
          }
          if (state is HealthChecking) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking health status...'),
                ],
              ),
            );
          }
          if (state is HealthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HealthBloc>().add(const CheckHealth());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is HealthChecked) {
            final healthData = state.healthData;
            final isHealthy = healthData['status'] == 'healthy';
            final upcomingDividends = healthData['upcoming_dividends'] as List?;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: isHealthy ? Colors.green[100] : Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isHealthy ? Icons.check_circle : Icons.error,
                                color: isHealthy ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status: ${healthData['status'].toUpperCase()}',
                                style: TextStyle(
                                  color: isHealthy ? Colors.green[900] : Colors.red[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Last Check: ${healthData['today']}'),
                          if (!isHealthy) ...[
                            const SizedBox(height: 8),
                            Text('Error: ${healthData['error']}'),
                            Text('Attempts: ${healthData['attempts']}'),
                            Text('Last Attempt: ${healthData['last_attempt']}'),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (isHealthy && upcomingDividends != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Upcoming Dividends',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...upcomingDividends.map((dividend) {
                      final record = DividendRecord.fromJson(dividend);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            '${record.symbol} - ${record.year} Q${record.quarter}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amount: ${record.amount}'),
                              Text('Yield: ${record.yieldPercent}%'),
                              Text('XD Date: ${record.xdDate}'),
                              Text('Pay Date: ${record.payDate}'),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 