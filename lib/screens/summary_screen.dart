import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividend_bloc.dart';
import '../models/dividend_record.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late int selectedYear;
  late List<int> years;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    years = List.generate(5, (i) => now.year - i);
    selectedYear = years.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DividendBloc>().add(LoadDividendsSummary(year: selectedYear.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dividend Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DividendBloc>().add(LoadDividendsSummary(year: selectedYear.toString()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Year: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: selectedYear,
                  items: years.map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  )).toList(),
                  onChanged: (year) {
                    if (year != null) {
                      setState(() {
                        selectedYear = year;
                      });
                      context.read<DividendBloc>().add(LoadDividendsSummary(year: year.toString()));
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DividendBloc, DividendState>(
              builder: (context, state) {
                if (state is DividendLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DividendError) {
                  return Center(
                    child: Text(
                      'Error: [31m[1m${state.message}[0m',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is DividendLoaded) {
                  return _buildSummaryContent(context, state.dividends);
                }
                return const Center(
                  child: Text('No dividend data available'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent(BuildContext context, List<DividendRecord> dividends) {
    // Calculate summary statistics
    final totalDividends = dividends.length;
    final totalAmount = dividends.fold<double>(
      0,
      (sum, record) => sum + (double.tryParse(record.amount) ?? 0),
    );
    final avgYield = dividends.fold<double>(
      0,
      (sum, record) => sum + (double.tryParse(record.yieldPercent) ?? 0),
    ) / (totalDividends > 0 ? totalDividends : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            context,
            'Overview',
            [
              _buildStatItem('Total Dividends', totalDividends.toString()),
              _buildStatItem('Total Amount', '฿${totalAmount.toStringAsFixed(2)}'),
              _buildStatItem('Average Yield', '${avgYield.toStringAsFixed(2)}%'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            'Recent Dividends',
            dividends.take(5).map((dividend) => _buildDividendItem(dividend)).toList(),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            'Top Yielding Stocks',
            _getTopYieldingStocks(dividends)
                .map((dividend) => _buildDividendItem(dividend))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividendItem(DividendRecord dividend) {
    return ListTile(
      title: Text(dividend.symbol),
      subtitle: Text('XD Date: ${dividend.xdDate}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '฿${dividend.amount}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${dividend.yieldPercent}%',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<DividendRecord> _getTopYieldingStocks(List<DividendRecord> dividends) {
    return List.from(dividends)
      ..sort((a, b) {
        final yieldA = double.tryParse(a.yieldPercent) ?? 0;
        final yieldB = double.tryParse(b.yieldPercent) ?? 0;
        return yieldB.compareTo(yieldA);
      })
      ..take(5);
  }
} 