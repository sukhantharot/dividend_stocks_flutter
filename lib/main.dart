import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/panphor_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/health_screen.dart';
import 'blocs/dividend_bloc.dart';
import 'blocs/health_bloc.dart';
import 'repositories/dividend_repository.dart';
import 'repositories/health_repository.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DividendRepository(),
        ),
        RepositoryProvider(
          create: (context) => HealthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DividendBloc(
              dividendRepository: context.read<DividendRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HealthBloc(
              healthRepository: context.read<HealthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Thai Stock Dividend',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/health',
          routes: {
            '/': (context) => const HomeScreen(),
            '/panphor': (context) => const PanphorScreen(),
            '/summary': (context) => const SummaryScreen(),
            '/health': (context) => const HealthScreen(),
          },
        ),
      ),
    );
  }
}
