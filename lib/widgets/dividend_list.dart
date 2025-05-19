import 'package:flutter/material.dart';
import '../models/dividend_record.dart';

class DividendList extends StatelessWidget {
  final List<DividendRecord> dividends;

  const DividendList({super.key, required this.dividends});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dividends.length,
      itemBuilder: (context, index) {
        final dividend = dividends[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(
              '${dividend.symbol} - ${dividend.year} Q${dividend.quarter}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Amount: ${dividend.amount}'),
                Text('Yield: ${dividend.yieldPercent}%'),
                Text('XD Date: ${dividend.xdDate}'),
                Text('Pay Date: ${dividend.payDate}'),
                Text('Type: ${dividend.type}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
} 