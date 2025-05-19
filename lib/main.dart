import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/panphor_screen.dart';
import 'screens/summary_screen.dart';
import 'blocs/dividend_bloc.dart';
import 'repositories/dividend_repository.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DividendRepository(),
      child: BlocProvider(
        create: (context) => DividendBloc(
          dividendRepository: context.read<DividendRepository>(),
        ),
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
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/panphor': (context) => const PanphorScreen(),
            '/summary': (context) => const SummaryScreen(),
          },
        ),
      ),
    );
  }
}
