import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividend_bloc.dart';
import '../widgets/dividend_list.dart';
import '../widgets/search_bar.dart';

class PanphorScreen extends StatelessWidget {
  const PanphorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panphor Dividend'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh for Panphor
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DividendSearchBar(
              onSearch: (symbol) {
                context.read<DividendBloc>().add(LoadDividendsPanphor(symbol));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DividendBloc, DividendState>(
              builder: (context, state) {
                if (state is DividendInitial) {
                  return const Center(
                    child: Text('Enter a stock symbol to search'),
                  );
                }
                if (state is DividendLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is DividendError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is DividendLoaded) {
                  return DividendList(dividends: state.dividends);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
} 