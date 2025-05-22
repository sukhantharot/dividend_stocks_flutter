import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividend_bloc.dart';
import '../widgets/dividend_list.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load upcoming dividends when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DividendBloc>().add(const LoadUpcomingDividends());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thai Stock Dividend'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'panphor':
                  Navigator.pushNamed(context, '/panphor');
                  break;
                case 'summary':
                  context.read<DividendBloc>().add(const LoadDividendsSummary());
                  break;
                case 'upcoming':
                  context.read<DividendBloc>().add(const LoadUpcomingDividends());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'panphor',
                child: Text('Panphor'),
              ),
              const PopupMenuItem<String>(
                value: 'summary',
                child: Text('Summary'),
              ),
              const PopupMenuItem<String>(
                value: 'upcoming',
                child: Text('Upcoming Dividends'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DividendBloc>().add(const LoadUpcomingDividends());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: DividendSearchBar(
          //     onSearch: (symbol) {
          //       context.read<DividendBloc>().add(LoadDividends(symbol));
          //     },
          //   ),
          // ),
          Expanded(
            child: BlocBuilder<DividendBloc, DividendState>(
              builder: (context, state) {
                if (state is DividendInitial) {
                  return const Center(
                    child: Text('Loading upcoming dividends...'),
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